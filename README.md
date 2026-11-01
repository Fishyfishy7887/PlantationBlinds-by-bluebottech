# PlantationBlinds
DIY Automated Plantation Blinds

## XIAO ESP32-C6 / L298N / NEMA 17 conversion

The current conversion adds a NEMA 17 motor mount, selectable-radius crank arm, linkage, optional shaft spacer, and a new electronics box for the XIAO ESP32-C6 and L298N. The original shutter clasp parts remain compatible and are retained.

Use `BBTArduino_XIAO_L298N.ino` for the MQTT/Home Assistant controller and `BBT_L298N_Motor_Test.ino` for the first bench test. See `XIAO_L298N_WIRING.md` and `BBT_NEMA17_CONVERSION_README.md` for wiring, calibration, and print notes.

## Visual-layout parts

The `BBT_VISUAL_LAYOUT.scad` set matches the illustrated tall frame bracket, electronics box above the NEMA17, exposed crank arm, and long vertical linkage. See `BBT_VISUAL_LAYOUT_README.md`; the original clasp A/B parts are reused.

**Associated Video**
https://www.youtube.com/watch?v=Hwe4bTJaqzg
