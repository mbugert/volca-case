include <laserscad.scad>

include <modules/case_dimensions.scad>
use <modules/lid.scad>
use <modules/bottom_case.scad>
use <modules/volca_unit.scad>


module full_case() {
    color("aqua", 0.55) bottom_case();
    color("lightsalmon", 0.55) lid();
}

ldummy() volca();
full_case();