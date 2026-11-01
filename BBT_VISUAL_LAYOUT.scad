// Visual-layout version matching Automated Plantation Shutter Actuator Diagram.png
// Tall frame bracket, electronics box above, NEMA17 below, exposed crank/linkage.
$fn=48;
part="motor_mount";

module rounded_box(s=[10,10,10],r=2){ hull(){ for(x=[r,s[0]-r],y=[r,s[1]-r],z=[r,s[2]-r]) translate([x,y,z]) sphere(r=r); } }
module slot(len=20,w=5,h=12){ hull(){ translate([-len/2,0,0]) cylinder(d=w,h=h,center=true); translate([len/2,0,0]) cylinder(d=w,h=h,center=true); } }
module hole(d=3.4,h=20){ cylinder(d=d,h=h,center=true); }

module motor_mount(){
    // Tall frame plate with motor lower section and electronics-box shelf above.
    difference(){
        union(){
            rounded_box([72,132,6],4);                         // frame plate
            translate([4,5,6]) rounded_box([64,62,8],3);       // NEMA17 front plate
            translate([4,70,6]) rounded_box([64,34,8],3);      // electronics shelf
            translate([4,5,14]) cube([7,62,12]);              // motor side cheek
            translate([61,5,14]) cube([7,62,12]);
        }
        // NEMA17 31 mm pattern, shaft forward through +Z
        for(x=[36-15.5,36+15.5],y=[36-15.5,36+15.5]) translate([x,y,10]) hole(3.5,20);
        translate([36,36,10]) cylinder(d=24,h=20,center=true);
        // Frame slots
        translate([10,12,3]) rotate([90,0,0]) slot(26,5,16);
        translate([62,12,3]) rotate([90,0,0]) slot(26,5,16);
        translate([10,120,3]) rotate([90,0,0]) slot(26,5,16);
        translate([62,120,3]) rotate([90,0,0]) slot(26,5,16);
        // Motor cable and box cable pass-throughs
        translate([36,67,3]) cube([18,12,10],center=true);
        translate([36,99,3]) cube([18,12,10],center=true);
    }
}

module crank_arm(){
    // Simple exposed crank matching the diagram: 5 mm shaft hub and one end pivot.
    difference(){
        hull(){ translate([8,8,4]) cylinder(d=18,h=8,center=true); translate([58,8,4]) cylinder(d=14,h=8,center=true); }
        translate([8,8,4]) cylinder(d=5.3,h=18,center=true);
        translate([58,8,4]) cylinder(d=4.2,h=18,center=true);
    }
}

module linkage_arm(){
    // Long vertical linkage shown between crank and original clasp.
    difference(){
        hull(){ translate([7,7,4]) cylinder(d=14,h=8,center=true); translate([7,77,4]) cylinder(d=14,h=8,center=true); }
        translate([7,7,4]) cylinder(d=4.2,h=18,center=true);
        translate([7,77,4]) cylinder(d=4.2,h=18,center=true);
    }
}

module parts_box_base(){
    // Tall visual-style box: 84 x 62 x 34, one XIAO + one L298N.
    difference(){
        rounded_box([84,62,34],5);
        translate([3,3,3]) rounded_box([78,56,34],4);
        translate([7,8,22]) cube([47,43,15]);
        for(p=[[10,11],[53,11],[10,51],[53,51]]) translate([p[0],p[1],27]) hole(3.2,12);
        translate([61,10,22]) cube([18,23,15]);
        translate([84,27,16]) rotate([0,90,0]) cylinder(d=10,h=10,center=true);
        translate([42,63,16]) rotate([90,0,0]) cylinder(d=8,h=10,center=true);
    }
    for(p=[[7,7],[77,7],[7,55],[77,55]]) translate([p[0],p[1],3]) difference(){ cylinder(d=8,h=28); cylinder(d=3.2,h=30); }
}

module parts_box_lid(){
    difference(){
        rounded_box([84.5,62.5,5],5);
        translate([3,3,-1]) rounded_box([78.5,56.5,5],4);
        for(p=[[7,7],[77,7],[7,55],[77,55]]) translate([p[0],p[1],2.5]) hole(3.2,9);
        for(i=[0:5]) translate([12+i*6,55,2.5]) cube([3,10,8],center=true);
    }
}

if(part=="motor_mount") motor_mount();
if(part=="crank_arm") crank_arm();
if(part=="linkage_arm") linkage_arm();
if(part=="parts_box_base") parts_box_base();
if(part=="parts_box_lid") parts_box_lid();
