include <laserscad.scad>

include <submodules/case_dimensions.scad>

use <submodules/lid.scad>
use <submodules/bottom_case.scad>
use <submodules/safety_pin.scad>
use <submodules/volca_device.scad>


module full_case() {
    ltranslate([0,0,-zlen-rubber_feet_zlen])  
        color("aqua", alpha)
            bottom_case();
    
    color("lightsalmon", alpha)
        lid();
    
    ltranslate([0,safety_pin_center_y,safety_pin_z]) {
        safety_pin("safety_pin_left");
        ltranslate([xlen+tol,0,0])
            lrotate([0,0,180])
                safety_pin("safety_pin_right");
    }
}

ldummy() {
    volca();
}
full_case();