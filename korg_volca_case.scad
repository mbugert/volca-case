include <laserscad.scad>

include <modules/case_dimensions.scad>
use <modules/volca_unit.scad>
use <modules/lid/lid.scad>
use <modules/bottom/bottom_case.scad>

module full_case(alpha=0.55) {
    color("aqua", alpha) bottom_case();
    color("lightsalmon", alpha) lid();
}

ldummy() volca();
full_case();