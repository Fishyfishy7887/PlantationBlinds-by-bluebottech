# XIAO ESP32-C6 + L298N adaptation

## Power

- Motor supply positive → L298N `12V`/`VMOTOR` terminal.
- Motor supply negative → L298N `GND`.
- Leave the L298N 5V regulator jumper installed.
- L298N `5V` → XIAO ESP32-C6 `5V/VBUS`.
- L298N `GND` → XIAO `GND`.

Do not power the XIAO from USB at the same time as the external 5V connection unless the power paths are intentionally isolated.

## Motor

- NEMA17 coil A → L298N `OUT1` and `OUT2`.
- NEMA17 coil B → L298N `OUT3` and `OUT4`.
- Keep `ENA` and `ENB` jumpers installed.

## Control signals

| XIAO pin | L298N pin |
|---|---|
| D0 | IN1 |
| D1 | IN2 |
| D2 | IN3 |
| D3 | IN4 |

The sketch uses a four-wire full-step sequence, so it does not use the original EasyDriver STEP/DIR pins.

## Optional limits

Set `LIMITS_ENABLED` to `1`, then connect normally-open switches from D4 and D5 to GND. D4 is the open limit and D5 is the close limit.

## Calibration

Set `STEPS_PER_POSITION` by testing the arm. The repository's original value of 80 steps per position is only a starting point for the NEMA17 conversion. Start with the arm disconnected from the shutter, then connect it and use a low motor speed.
