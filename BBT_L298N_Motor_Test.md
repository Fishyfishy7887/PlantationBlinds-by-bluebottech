# NEMA 17 bench test

Upload `BBT_L298N_Motor_Test.ino` with the ESP32-C6 board profile. Open the Arduino Serial Monitor at **115200 baud** and send:

In Arduino IDE, set **Tools → USB CDC On Boot → Enabled**, then upload again. The sketch also performs a short 20-step forward/reverse test automatically after boot.

- `f` — 80 full steps forward
- `r` — 80 full steps reverse
- `a` — five forward/reverse cycles
- `s` — stop and release the coils
- `?` — show commands

Keep the motor disconnected from the shutter arm for the first test. If it only vibrates, power off and swap one wire within one motor coil, or identify the two coil pairs with a meter. The L298N `ENA` and `ENB` jumpers should remain installed.
