# NEMA 17 conversion parts

These parts replace the repository's small stepper mount and arm while retaining the original `blinds clasp A.stl` and `blinds clasp B.stl`.

- `BBT_NEMA17_motor_mount.stl`: 42 x 42 mm NEMA17 mount, 31 mm hole spacing, adjustable frame slots
- `BBT_NEMA17_arm.stl`: 5.3 mm shaft bore with 32, 44, and 56 mm linkage-radius holes
- `BBT_NEMA17_link.stl`: replacement link between the crank arm and the original clasp
- `BBT_NEMA17_shaft_spacer.stl`: optional spacer/hub
- `BBT_NEMA17_parts_box_base.stl`: new electronics box for the XIAO + L298N
- `BBT_NEMA17_parts_box_lid.stl`: removable ventilated lid
- `BBT_NEMA17_Electronics_Box.scad`: editable box source

Hardware: M3 motor screws, an M4 pivot bolt/pin for the arm/link, and a 5 mm shaft retaining screw or clamp. Start with the shortest arm hole (32 mm radius) to reduce torque on the plantation-shutter tilt mechanism. Test with the arm disconnected, then attach the clasp and use a low step rate.

The original clasp geometry is retained because its fit is specific to the shutter frame. The conversion mount has slots to allow alignment, but the exact frame-hole spacing may still require drilling or a small adapter plate.

The new parts box is sized around a common 43 x 43 mm L298N module and a XIAO ESP32-C6. Confirm the exact board connector locations before drilling or final printing.
