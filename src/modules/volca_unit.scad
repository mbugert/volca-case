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

include <case_dimensions.scad>

module volca() {
    module panel_screw() {
        cylinder(r=panel_screw_r, h=panel_screw_zlen);
    }
    
    // main body
    translate(tol*[0.5,0.5,0] + [0,0,-zlen-rubber_feet_zlen]) {
        cube([xlen, ylen, zlen+rubber_feet_zlen]);
    }
    
    translate([panel_screw_x,0,0]) {
        translate([0,ribbon_ylen+panel_screw_r,0]) panel_screw();
        translate([0,ylen+tol-panel_screw_back_y,0]) panel_screw();
    }
}