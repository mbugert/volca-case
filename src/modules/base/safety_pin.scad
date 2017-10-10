include <laserscad.scad>
include <lasercut.scad>

include <../case_dimensions.scad>


module safety_pin(id, kerf_delta=0) {
    if (safety_pin_inner_xlen > 0) {
        _safety_pin_sane(id, kerf_delta);
    } else {
        echo("WARNING: Thickness too high for removable safety pins.");
    }
}

module _safety_pin_sane(id, kerf_delta) {
    x = safety_pin_inner_xlen;
    y = safety_pin_ylen;
    ltranslate([-t, -0.5*y, 0]) // center at origin
        lpart(str("pin_", id), [x+t,y])
            translate([t,0,0])
                linear_extrude(height=t)
                    // kerf variations here
                    offset(delta=kerf_delta) {
                        square([x, y]);
                        
                        // here, it's necessary to fix the bug in lasercut which always creates finger joints twice as long as they should be
                        intersection() {
                            projection()
                                fingerJoint(LEFT, 1, 2, t, 4/3 * y, 0, 0, 0, true);
                            translate([-t,0])
                                square([t, y]);
                        }
                    }
}

module safety_pin_cutout() {
    y = safety_pin_ylen;
    dif = 1;
    
    translate([-dif,-0.5*y,0])
        fingerJoint(LEFT, 1, 2, t, 4/3 * y, 0, 0, 0, false);
}

safety_pin("");