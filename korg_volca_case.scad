include <laserscad.scad>

include <modules/case_dimensions.scad>
use <modules/volca_unit.scad>
use <modules/lid/lid.scad>
use <modules/base/base.scad>

module full_case(alpha=0.55) {
    color("aqua", alpha) base();
    color("lightsalmon", alpha) lid();
}

ldummy() volca();
full_case();

_laserscad_mode=2;