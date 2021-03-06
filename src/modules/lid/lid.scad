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

include <lid_dimensions.scad>
use <lid_back_free.scad>
use <lid_back_obstructed.scad>

module lid() {    
    ltranslate([-t,0,0]) {
        lrotate([90,0,0])
            lid_front();
        
        // is_back_free: volcas without knobs or buttons between the power and MIDI jack (at the time of writing: sample and beats)
        if(is_back_free) {
            lid_back_free();
        } else {
            lid_back_obstructed();
        }
    }
    
    // the dimensions of the left lid_side part depend on the unit
    io_bezel_cover_y = is_back_free? audio_jack_corner_dims[1] : power_jack_corner_dims[1];
    lid_side("lid_left", io_bezel_cover_y);
    
    ltranslate([x+t,0,0])
        lid_side("lid_right", audio_jack_corner_dims[1]);
}


module lid_front() {
    lpart("lid_front", [x+2*t, lid_z+t])
        translate([t,0,0])
            lasercutoutSquare(thickness=t, x=x, y=lid_z,
                finger_joints=[
                    [UP,1,6],
                    [LEFT,0,2],
                    [RIGHT,1,2]
                ]);
}


module lid_side(id, io_bezel_cover_y) {
    dif = 1;
    lid_top_y = y - io_bezel_cover_y - t;
    
    lrotate([0,-90,0])
        ltranslate([-case_wave_amplitude,-t,0])
            lpart(id, [case_wave_amplitude+lid_z+t, y+2*t])
                translate([case_wave_amplitude,t,0]) {
                    difference() {
                        union() {
                            linear_extrude(height=t) {
                                square([lid_z, lid_top_y]);
                                translate([0,lid_top_y])
                                    square([bezel_safety_zlen, io_bezel_cover_y+2*t]);
                            }
                            
                            // all them joints
                            fingerJoint(DOWN, 0, 2, t, 0, 0, lid_z, 0);
                            fingerJoint(RIGHT, 0, 4, t, lid_top_y, 0, lid_z, 0);
                            translate([bezel_safety_zlen+t,0,0])
                                fingerJoint(UP, 0, 1, t, lid_top_y, 0, lid_back_z, 0);
                            translate([0,lid_top_y+t,0])
                                fingerJoint(RIGHT, 1, 2, t, io_bezel_cover_y+t, 0, bezel_safety_zlen, 0);
                            
                            // missing corners for finger joints
                            translate([bezel_safety_zlen,lid_top_y,0])
                                cube(t);
                            translate([lid_z,-t,0])
                                cube(t);
                        }
                        
                        // remove the top bump of the wave which will contain the safety pin
                        translate([0,0,-dif])
                            linear_extrude(height=t+2*dif) {
                                case_wave(true);
                                
                                // to ensure valid 2-manifold
                                translate([-dif,0])
                                    square([dif, y]);
                            }
                        
                        // remove some part from the bottom because lasercut always creates those badly overlapping joints
                        translate([-case_wave_amplitude,0,-dif])
                            cube([case_wave_amplitude, y+t+dif, t+2*dif]);
                    }
                    
                    // add bottom two bumps of the wave
                    linear_extrude(height=t)
                        case_wave(false);
                }
}
lid();