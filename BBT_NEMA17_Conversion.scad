// NEMA17 conversion for PlantationBlinds-by-bluebottech
// Replaces the small stepper mount/arm while retaining the repository clasp.
// Units: mm. Designed for ASA, 0.20 mm layers, 4 walls.

$fn=64;
part="motor_mount";

module slot(len=20,w=5,h=12){
    hull(){
        translate([-len/2,0,0]) cylinder(d=w,h=h,center=true);
        translate([ len/2,0,0]) cylinder(d=w,h=h,center=true);
    }
}

module rounded_box(s=[10,10,10],r=2){
    hull(){ for(x=[r,s[0]-r],y=[r,s[1]-r],z=[r,s[2]-r]) translate([x,y,z]) sphere(r=r); }
}

module motor_mount(){
    // 72 x 72 face plate for 42 mm NEMA17. Motor shaft points through +Z.
    difference(){
        union(){
            rounded_box([72,72,8],5);
            translate([36,36,8]) cylinder(d=54,h=6);
            // Frame mounting ears
            translate([8,36,4]) rotate([90,0,0]) cylinder(d=10,h=8,center=true);
            translate([64,36,4]) rotate([90,0,0]) cylinder(d=10,h=8,center=true);
        }
        // NEMA17 31 mm mounting pattern
        for(x=[36-15.5,36+15.5],y=[36-15.5,36+15.5])
            translate([x,y,8]) cylinder(d=3.5,h=20,center=true);
        translate([36,36,8]) cylinder(d=24,h=20,center=true);
        // Slotted frame attachment holes; allows alignment with existing arm/clasp
        translate([8,36,4]) rotate([90,0,0]) slot(24,5,16);
        translate([64,36,4]) rotate([90,0,0]) slot(24,5,16);
        // Cable relief
        translate([36,68,4]) cube([18,12,10],center=true);
    }
}

module arm(){
    // Direct replacement crank arm for a 5 mm NEMA17 shaft.
    // Three selectable linkage holes give 32/44/56 mm radius options.
    difference(){
        union(){
            cylinder(d=22,h=10,center=true);
            hull(){
                translate([8,0,0]) cylinder(d=16,h=10,center=true);
                translate([56,0,0]) cylinder(d=16,h=10,center=true);
            }
        }
        cylinder(d=5.3,h=18,center=true);
        for(x=[32,44,56]) translate([x,0,0]) cylinder(d=4.2,h=18,center=true);
    }
}

module link(){
    // Link between crank arm and the repository clasp. Use an M4 bolt/pin.
    difference(){
        hull(){
            translate([6,8,4]) cylinder(d=16,h=8,center=true);
            translate([56,8,4]) cylinder(d=16,h=8,center=true);
        }
        translate([6,8,4]) cylinder(d=4.2,h=16,center=true);
        translate([56,8,4]) cylinder(d=4.2,h=16,center=true);
    }
}

module shaft_spacer(){
    // Optional 5 mm shaft hub spacer; use only if the arm needs extra stand-off.
    difference(){
        cylinder(d=18,h=6,center=true);
        cylinder(d=5.3,h=12,center=true);
        rotate([0,90,0]) cylinder(d=3.2,h=22,center=true);
    }
}

module motor_box_mount(){
    // Boxed cradle matching the concept diagram: NEMA17 body sits in a
    // protected pocket, with the shaft and crank exiting the front.
    difference(){
        union(){
            rounded_box([62,62,58],5);
            // frame mounting ears on the lower sides
            translate([6,31,8]) rotate([90,0,0]) cylinder(d=11,h=10,center=true);
            translate([56,31,8]) rotate([90,0,0]) cylinder(d=11,h=10,center=true);
        }
        // motor pocket; front flange remains 6 mm thick
        translate([7,7,6]) cube([48,48,55]);
        // front shaft opening and NEMA17 31 mm bolt pattern
        translate([31,31,2]) cylinder(d=24,h=12,center=true);
        for(x=[31-15.5,31+15.5],y=[31-15.5,31+15.5])
            translate([x,y,3]) cylinder(d=3.5,h=14,center=true);
        // rear cable opening
        translate([31,31,57]) cube([18,18,10],center=true);
        // frame attachment slots
        translate([6,31,8]) rotate([90,0,0]) slot(24,5,18);
        translate([56,31,8]) rotate([90,0,0]) slot(24,5,18);
    }
}

if(part=="motor_mount") motor_mount();
if(part=="arm") arm();
if(part=="link") link();
if(part=="shaft_spacer") shaft_spacer();
if(part=="motor_box_mount") motor_box_mount();
