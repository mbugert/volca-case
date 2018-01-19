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

include <../engravings.scad>

include <lid_dimensions.scad>
use <io_cutouts.scad>

module bezel_power_cover() {
    bezel_y=power_jack_corner_dims[1]+t;
    
    module bezel_power_cover_shape() {
        difference() {
            lasercutoutSquare(thickness=t, x=power_jack_x, y=bezel_y,
                              finger_joints=[
                                [DOWN,1,2],
                                [LEFT,1,2]
                              ]);
            translate([0,bezel_y-t,0])
                io_cutouts();
        }
    }
    
    lpart("bezel_power_cover", [power_jack_x, bezel_y] + [t,t]) {
        translate([t,t,0]) {
            bezel_power_cover_shape();
        
            if (engravings) {
                lengrave(t, true)
                    intersection() {
                        translate([0,bezel_y-y-t])
                            engraving_line_art("../");
                        projection()
                            bezel_power_cover_shape();
                }
            }
        }
    }
}

module bezel_audio_cover() {
    bezel_y=audio_jack_corner_dims[1]+t;
    
    module bezel_audio_cover_shape() {
        difference() {
            lasercutoutSquare(thickness=t, x=midi_jack_x, y=bezel_y,
                              finger_joints=[
                                [DOWN,0,2],
                                [RIGHT,0,2]
                              ]);
            translate([-x+midi_jack_x,bezel_y-t,0])
                io_cutouts();
        }
    }
    
    lpart("bezel_audio_cover", [midi_jack_x,bezel_y]+t*[1,1]) {
        translate([0,t,0]) {
            bezel_audio_cover_shape();     
            
            if (engravings) {
                lengrave(t, true)
                    intersection() {
                        translate([midi_jack_x-x,bezel_y-y-t])
                            engraving_line_art("../");
                        projection()
                            bezel_audio_cover_shape();
                }
            }
        }        
    }
}

module lid_power_back() {
    x = power_jack_corner_dims[0];
    y = lid_back_z;
    corner_fill_x = power_jack_r + jack_r_padding;

    lpart("lid_power_back", [x,y]+t*[2,2]) {
        translate([t,t,0]) {
            linear_extrude(height=t) {
                square([x,y]);
                // this square replaces the inside corner near the power jack
                translate([x-corner_fill_x,-t])
                    square([corner_fill_x, t]);
            }
            fingerJoint(UP,1,2, t, y, 0, x, 0);
            translate([0,-t,0])
                fingerJoint(RIGHT,1,2, t, y+t, 0, x, 0);
            fingerJoint(LEFT,1,1, t, y, 0, x, 0);
            fingerJoint(DOWN,0,2, t, y, 0, x-corner_fill_x, 0);
            
            // fix missing corner in finger joints
            translate([-t,y,0])
                cube(t);
        }
    }
}

module lid_audio_back() {
    x = audio_jack_corner_dims[0];
    y = lid_back_z;
    lpart("lid_audio_back", [x,y]+t*[2,2]) {
        translate([t,t,0]) {
            linear_extrude(height=t) {
                square([x,y]);
                // this square replaces the inside corner near the MIDI jack
                translate([0,-t])
                    square([midi_jack_r+jack_r_padding, t]);
            }
            
            fingerJoint(UP,0,4, t, y, 0, x, 0);
            translate([x-midi_jack_x,0,0])
                fingerJoint(DOWN,1,2, t, y, 0, midi_jack_x, 0);
            fingerJoint(RIGHT,0,1, t, y, 0, x, 0);
            translate([0,-t,0])
                fingerJoint(LEFT,0,2, t, y+t, 0, x, 0);
            
            // fix missing corner in finger joint
            translate([x,y])
                cube(t);
        }
    }
}

module lid_power_side() {
    x = lid_back_z+t;
    y = power_jack_corner_dims[1];
    
    lpart("lid_power_side", [x,y]+t*[1,2]) {
        translate([0,t,0]) {
            lasercutoutSquare(thickness=t, x=x, y=y,
                              finger_joints=[
                                [RIGHT,0,2],
                                [UP,1,2],
                                [DOWN,0,2]
                              ]);
            // fix missing corner in finger joints
            translate([x,-t,0])
                cube(t);
        }
    }    
}

module lid_audio_side() {
    x = lid_back_z+t;
    y = audio_jack_corner_dims[1];
    lpart("lid_audio_side", [x,y]+t*[1,2]) {
        translate([0,t,0]) {
            lasercutoutSquare(thickness=t, x=x, y=y,
                              finger_joints=[
                                [RIGHT,0,2],
                                [UP,0,2],
                                [DOWN,0,2]
                              ]);            
        }
        // fix missing corner in finger joints
        translate([x,y+t,0])
            cube(t);
        translate([x,0,0])
            cube(t);
    }
}

module lid_obstructed_back() {
    x = x - audio_jack_corner_dims[0] - power_jack_corner_dims[0] - 2*t;
    y = lid_back_z+t;
    lpart("lid_obstructed_back", [x,y] + [2*t,t])
        translate([t,0,0]) {
            lasercutoutSquare(thickness=t, x=x, y=y,
                              finger_joints=[
                                [UP,0,4],
                                [RIGHT,0,2],
                                [LEFT,0,2]
                              ]);
            // fix missing corner in finger joints
            translate([-t,y])
                cube(t);
        }
}

module lid_obstructed_top() {
    module lid_obstructed_top_shape() {
        linear_extrude(height=t)
            difference() {
                square([x, y]);
                dif = 1;
                
                // remove the power jack corner
                translate([0,y - power_jack_corner_dims[1]- t] - dif*[1,0])
                    square(power_jack_corner_dims + (t+dif)*[1,1]);

                // remove the io jack corner
                translate([x,y] - audio_jack_corner_dims - t*[1,1])
                    square(audio_jack_corner_dims + (t+dif)*[1,1]);
            }
            
        // finger joints, counter-clockwise starting from the origin
        fingerJoint(DOWN, 1, 6, t, y, 0, x, 0);
        fingerJoint(RIGHT, 1, 4, t, y-audio_jack_corner_dims[1]-t, 0, x, 0);
        translate([x,y-t,0] - audio_jack_corner_dims)
            fingerJoint(UP, 1, 4, t, 0, 0, audio_jack_corner_dims[0], 0);
        translate([x-t,y,0] - audio_jack_corner_dims)
            fingerJoint(RIGHT, 1, 2, t, audio_jack_corner_dims[1], 0, 0, 0);
        translate([power_jack_corner_dims[0]+t, 0, 0])
            fingerJoint(UP, 1, 4, t, y, 0, x-power_jack_corner_dims[0]-audio_jack_corner_dims[0]-2*t, 0);
        translate([power_jack_corner_dims[0]+t, y - power_jack_corner_dims[1]])
            fingerJoint(LEFT, 0, 2, t, power_jack_corner_dims[1], 0, 0, 0);
        fingerJoint(UP, 0, 2, t, y-power_jack_corner_dims[1]-t, 0, power_jack_corner_dims[0], 0);
        fingerJoint(LEFT, 0, 4, t, y-power_jack_corner_dims[1]-t, 0, 0, 0);
    }    
    
    lpart("lid_obstructed_top", [x, y] + t*[2,2]) {
        translate([t,t,0]) {
            lid_obstructed_top_shape();

            if (engravings)
                lengrave(t, true)
                    intersection() {
                        engraving_line_art("../");
                        projection()
                            lid_obstructed_top_shape();
                    }
        }
    }
}

module lid_back_obstructed() {
    ltranslate([0,-t,lid_z])
        lid_obstructed_top();
    
    ltranslate([0,0,bezel_safety_zlen]) {
        // back/side of audio jack corner
        ltranslate([x,y,0] - audio_jack_corner_dims) {
            lrotate([90,0,0])
                lid_audio_back();
            ltranslate([t,-t,0])
                lrotate([0,-90,0])
                    lid_audio_side();
        }
        
        // bezel cover of audio jack corner
        ltranslate([x,y,0] - [midi_jack_x,audio_jack_corner_dims[1],0] + [t,-t,0])
            bezel_audio_cover();
        
        // back of the lid
        ltranslate([power_jack_corner_dims[0], y, 0] + [t,t,0])
            lrotate([90,0,0])
                lid_obstructed_back();
        
        // back/side of power jack corner
        ltranslate([0, y-power_jack_corner_dims[1], 0]) {
            ltranslate([power_jack_corner_dims[0] + 2*t,-t,0])
                lrotate([0,-90,0])
                    lid_power_side();
            lrotate([90,0,0])
                lid_power_back();
            ltranslate([0,-t,0])
                bezel_power_cover();
        }            
    }
}
lid_back_obstructed();