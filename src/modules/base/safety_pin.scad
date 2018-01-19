// Copyright 2018, mbugert
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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