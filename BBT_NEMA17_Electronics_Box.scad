// New electronics box for XIAO ESP32-C6 + L298N.
// ASA print, mm. Set part to "base" or "lid" for STL export.
$fn=48;
part="base";
W=100; D=70; H=38; wall=3; r=5;

module rounded_box(s=[10,10,10],rad=2){
    hull(){ for(x=[rad,s[0]-rad],y=[rad,s[1]-rad],z=[rad,s[2]-rad]) translate([x,y,z]) sphere(r=rad); }
}
module screw_hole(d=3.2,h=10){ cylinder(d=d,h=h,center=true); }
module vent_slots(){
    for(i=[0:5]) translate([54+i*6, D-wall/2, 17]) rotate([90,0,0]) hull(){
        cylinder(d=2.4,h=wall+3,center=true);
        translate([0,10,0]) cylinder(d=2.4,h=wall+3,center=true);
    }
}

module base(){
    difference(){
        rounded_box([W,D,H],r);
        translate([wall,wall,wall]) rounded_box([W-2*wall,D-2*wall,H],r-1);

        // L298N board cavity and four M3 standoff holes
        translate([7,10,H-12]) cube([47,47,16]);
        for(p=[[10,13],[53,13],[10,56],[53,56]])
            translate([p[0],p[1],H-7]) screw_hole(3.2,14);

        // XIAO mounting shelf / cable clearance
        translate([64,11,H-11]) cube([25,24,15]);
        for(x=[67,84]) translate([x,9,H-7]) cube([3,28,6],center=true);

        // Power and motor cable exits
        translate([W+1,28,18]) rotate([0,90,0]) cylinder(d=10,h=10,center=true);
        translate([-1,42,18]) rotate([0,90,0]) cylinder(d=10,h=10,center=true);
        translate([37,D+1,18]) rotate([90,0,0]) cylinder(d=8,h=10,center=true);
        vent_slots();
    }

    // Lid screw bosses
    for(p=[[7,7],[W-7,7],[7,D-7],[W-7,D-7]])
        translate([p[0],p[1],wall]) difference(){
            cylinder(d=8,h=H-wall-2);
            cylinder(d=3.2,h=H-wall);
        }
}

module lid(){
    difference(){
        rounded_box([W+0.5,D+0.5,5],r);
        translate([wall,wall,-1]) rounded_box([W-2*wall,D-2*wall,5],r-1);
        for(p=[[7,7],[W-7,7],[7,D-7],[W-7,D-7]])
            translate([p[0],p[1],2.5]) screw_hole(3.2,9);
        // L298N heatsink ventilation and status LED window
        for(i=[0:5]) translate([12+i*6, D-16, 2.5]) cube([3,10,8],center=true);
        translate([78,7,2.5]) cylinder(d=6,h=8,center=true);
    }
}

if(part=="base") base();
if(part=="lid") lid();
