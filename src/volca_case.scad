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

include <modules/case_dimensions.scad>
use <modules/volca_unit.scad>
use <modules/lid/lid.scad>
use <modules/base/base.scad>

module full_case(alpha=0.8) {
    color("aqua", alpha) base();
    color("lightsalmon", alpha) lid();
}

ldummy() volca();
full_case();