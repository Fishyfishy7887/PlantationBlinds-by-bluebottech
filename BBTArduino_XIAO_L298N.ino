// PlantationBlinds adaptation for Seeed Studio XIAO ESP32-C6 + L298N + NEMA 17
// Preserves the original MQTT topics and OPEN/CLOSE/STOP behavior.
// L298N ENA/ENB jumpers stay installed; four GPIOs drive IN1..IN4.

#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoOTA.h>

// ---------------- user configuration ----------------
#define USER_SSID             "BlueBotWifiNetwork"
#define USER_PASSWORD         "BlueBotPassword"
#define USER_MQTT_SERVER      "192.168.1.XXX"
#define USER_MQTT_PORT        1883
#define USER_MQTT_USERNAME     "BlueBotMQTT"
#define USER_MQTT_PASSWORD     "BlueBotMQTTPassword"
#define USER_MQTT_CLIENT_NAME  "BlueBotBlinds"

// XIAO ESP32-C6 GPIO mapping. Numeric GPIOs are used instead of D0/D1 aliases
// so this sketch also compiles when the generic "ESP32C6 Dev Module" profile
// is selected in Arduino IDE.
// L298N: IN1/IN2 = motor coil A; IN3/IN4 = motor coil B.
const int IN1_PIN = 0;   // XIAO D0
const int IN2_PIN = 1;   // XIAO D1
const int IN3_PIN = 2;   // XIAO D2
const int IN4_PIN = 21;  // XIAO D3

// Optional normally-open limit switches to GND. Set to 1 after wiring them.
#define LIMITS_ENABLED 0
const int LIMIT_OPEN_PIN  = 22; // XIAO D4
const int LIMIT_CLOSE_PIN = 23; // XIAO D5

// Original project uses 12 logical positions and 80 motor steps per position.
// Tune STEPS_PER_POSITION for the NEMA17/arm geometry.
const long STEPS_PER_POSITION = 80;
const int MAX_POSITION = 12;
const unsigned long STEP_INTERVAL_US = 2500; // lower = faster

WiFiClient wifiClient;
PubSubClient mqtt(wifiClient);

long currentStep = 0;
long targetStep = 0;
int currentPosition = 0;
int targetPosition = 0;
int phase = 0;
bool moving = false;
unsigned long lastStepMicros = 0;
unsigned long lastCheckIn = 0;

const int sequence[4][4] = {
  {1, 0, 1, 0},
  {0, 1, 1, 0},
  {0, 1, 0, 1},
  {1, 0, 0, 1}
};

void coilsOff() {
  digitalWrite(IN1_PIN, LOW);
  digitalWrite(IN2_PIN, LOW);
  digitalWrite(IN3_PIN, LOW);
  digitalWrite(IN4_PIN, LOW);
}

void applyPhase() {
  digitalWrite(IN1_PIN, sequence[phase][0]);
  digitalWrite(IN2_PIN, sequence[phase][1]);
  digitalWrite(IN3_PIN, sequence[phase][2]);
  digitalWrite(IN4_PIN, sequence[phase][3]);
}

bool limitHit(bool closing) {
#if LIMITS_ENABLED
  int pin = closing ? LIMIT_CLOSE_PIN : LIMIT_OPEN_PIN;
  return digitalRead(pin) == LOW;
#else
  (void)closing;
  return false;
#endif
}

void publishPosition() {
  char buffer[16];
  snprintf(buffer, sizeof(buffer), "%d", currentPosition);
  mqtt.publish("BlueBotBlinds/positionState", buffer, true);
}

void stopMotion() {
  targetStep = currentStep;
  targetPosition = currentPosition;
  moving = false;
  coilsOff();
  publishPosition();
}

void stepOnce(bool closing) {
  if (limitHit(closing)) {
    stopMotion();
    return;
  }

  if (closing) {
    phase = (phase + 1) & 3;
    currentStep++;
  } else {
    phase = (phase + 3) & 3;
    currentStep--;
  }
  applyPhase();
}

void processStepper() {
  if (currentStep == targetStep) {
    if (moving) {
      moving = false;
      currentPosition = targetPosition;
      coilsOff();
      publishPosition();
    }
    return;
  }

  unsigned long now = micros();
  if ((unsigned long)(now - lastStepMicros) < STEP_INTERVAL_US) return;
  lastStepMicros = now;
  moving = true;
  stepOnce(targetStep > currentStep);
}

void connectWifi() {
  WiFi.mode(WIFI_STA);
  WiFi.begin(USER_SSID, USER_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) delay(500);
}

void reconnectMqtt() {
  while (!mqtt.connected()) {
    if (mqtt.connect(USER_MQTT_CLIENT_NAME, USER_MQTT_USERNAME, USER_MQTT_PASSWORD)) {
      mqtt.subscribe("BlueBotBlinds/blindsCommand");
      mqtt.subscribe("BlueBotBlinds/positionCommand");
      mqtt.publish("BlueBotBlinds/checkIn", "Connected");
    } else {
      delay(3000);
    }
  }
}

void mqttCallback(char* topic, byte* payload, unsigned int length) {
  String message;
  for (unsigned int i = 0; i < length; i++) message += (char)payload[i];

  String topicName(topic);
  if (topicName == "BlueBotBlinds/blindsCommand") {
    if (message == "OPEN") targetPosition = 0;
    else if (message == "CLOSE") targetPosition = MAX_POSITION;
    else if (message == "STOP") { stopMotion(); return; }
  } else if (topicName == "BlueBotBlinds/positionCommand") {
    targetPosition = constrain(message.toInt(), 0, MAX_POSITION);
  } else {
    return;
  }

  targetStep = (long)targetPosition * STEPS_PER_POSITION;
  moving = true;
}

void setup() {
  pinMode(IN1_PIN, OUTPUT);
  pinMode(IN2_PIN, OUTPUT);
  pinMode(IN3_PIN, OUTPUT);
  pinMode(IN4_PIN, OUTPUT);
  coilsOff();

#if LIMITS_ENABLED
  pinMode(LIMIT_OPEN_PIN, INPUT_PULLUP);
  pinMode(LIMIT_CLOSE_PIN, INPUT_PULLUP);
#endif

  connectWifi();
  mqtt.setServer(USER_MQTT_SERVER, USER_MQTT_PORT);
  mqtt.setCallback(mqttCallback);
  ArduinoOTA.setHostname(USER_MQTT_CLIENT_NAME);
  ArduinoOTA.begin();
}

void loop() {
  if (!mqtt.connected()) reconnectMqtt();
  mqtt.loop();
  ArduinoOTA.handle();
  processStepper();

  if (millis() - lastCheckIn > 90000) {
    lastCheckIn = millis();
    mqtt.publish("BlueBotBlinds/checkIn", "OK");
  }
}
