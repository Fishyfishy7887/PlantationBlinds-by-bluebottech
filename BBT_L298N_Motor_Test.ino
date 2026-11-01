// Bench test for XIAO ESP32-C6 + L298N + NEMA 17.
// Open Serial Monitor at 115200 baud and send:
//   f = move forward 80 full steps
//   r = move reverse 80 full steps
//   a = run five forward/reverse cycles
//   s = stop and release motor coils
//   ? = show help

const int IN1_PIN = 0;   // XIAO D0 -> L298N IN1
const int IN2_PIN = 1;   // XIAO D1 -> L298N IN2
const int IN3_PIN = 2;   // XIAO D2 -> L298N IN3
const int IN4_PIN = 21;  // XIAO D3 -> L298N IN4

const int TEST_STEPS = 80;
const unsigned long STEP_DELAY_US = 3000;
const bool AUTO_TEST_ON_BOOT = true;

const int sequence[4][4] = {
  {1, 0, 1, 0},
  {0, 1, 1, 0},
  {0, 1, 0, 1},
  {1, 0, 0, 1}
};

int phase = 0;

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

void oneStep(bool forward) {
  if (forward) phase = (phase + 1) & 3;
  else phase = (phase + 3) & 3;
  applyPhase();
  delayMicroseconds(STEP_DELAY_US);
}

void moveMotor(int steps, bool forward) {
  Serial.printf("Moving %d steps %s\n", steps, forward ? "forward" : "reverse");
  for (int i = 0; i < steps; i++) {
    oneStep(forward);
    if (Serial.available() && Serial.read() == 's') break;
  }
  coilsOff();
  Serial.println("Done; coils released");
}

void printHelp() {
  Serial.println("Commands: f=forward, r=reverse, a=5 cycles, s=release, ?=help");
  Serial.println("Test is 80 full steps at 3000 us per step.");
}

void setup() {
  pinMode(IN1_PIN, OUTPUT);
  pinMode(IN2_PIN, OUTPUT);
  pinMode(IN3_PIN, OUTPUT);
  pinMode(IN4_PIN, OUTPUT);
  coilsOff();
  Serial.begin(115200);
  delay(500);
  Serial.println("XIAO ESP32-C6 / L298N / NEMA17 bench test");
  printHelp();
  if (AUTO_TEST_ON_BOOT) {
    Serial.println("Automatic test starts in 3 seconds; disconnect the shutter arm first.");
    delay(3000);
    moveMotor(20, true);
    delay(500);
    moveMotor(20, false);
  }
}

void loop() {
  if (!Serial.available()) return;
  char command = Serial.read();
  if (command == 'f' || command == 'F') moveMotor(TEST_STEPS, true);
  else if (command == 'r' || command == 'R') moveMotor(TEST_STEPS, false);
  else if (command == 'a' || command == 'A') {
    for (int i = 0; i < 5; i++) {
      moveMotor(TEST_STEPS, true);
      delay(500);
      moveMotor(TEST_STEPS, false);
      delay(500);
    }
  } else if (command == 's' || command == 'S') {
    coilsOff();
    Serial.println("Stopped; coils released");
  } else if (command == '?') printHelp();
}
