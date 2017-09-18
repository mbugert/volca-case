include <laserscad.scad>
include <lasercut.scad>

include <../case_dimensions.scad>


module safety_pin(id) {
    x = safety_pin_inner_xlen;
    y = safety_pin_ylen;
    
    if (safety_pin_inner_xlen > 0) {
        ltranslate([-t, -0.5*y, 0])
            lpart(id, [x+t,y])
                translate([t,0,0]) {
                    cube([x, y, t]);
                    fingerJoint(LEFT, 1, 2, t, 4/3 * y, 0, x, 0, true);
                }
    } else {
        echo("WARNING: Thickness too high for removable safety pins.");
    }
}
module safety_pin_cutout() {
    y = safety_pin_ylen;
    dif = 1;
    
    translate([-dif,-0.5*y,0])
        fingerJoint(LEFT, 1, 2, t, 4/3 * y, 0, 0, 0, false);
}