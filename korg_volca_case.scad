include <laserscad.scad>

include <modules/case_dimensions.scad>
use <modules/volca_unit.scad>
use <modules/lid/lid.scad>
use <modules/bottom/bottom_case.scad>


module full_case() {
    color("aqua", 0.55) bottom_case();
    color("lightsalmon", 0.55) lid();
}

ldummy() volca();
full_case();