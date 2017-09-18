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
    lid_side("lid_left");
    
    ltranslate([x+t,0,0])
        lid_side("lid_right");
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


module lid_side(id) {
    dif = 1;
    
    lrotate([0,-90,0])
        ltranslate([-case_wave_amplitude,-t,0])
            lpart(id, [case_wave_amplitude+lid_z+t, y+2*t])
                translate([case_wave_amplitude,t,0]) {
                    difference() {
                        union() {
                            linear_extrude(height=t) {
                                square([lid_z, lid_top_y]);
                                translate([0,lid_top_y])
                                    square([bezel_safety_zlen, lid_bezel_io_cover_y+2*t]);
                            }
                            
                            // all them joints
                            fingerJoint(DOWN, 0, 2, t, 0, 0, lid_z, 0);
                            fingerJoint(RIGHT, 0, 4, t, lid_top_y, 0, lid_z, 0);
                            translate([bezel_safety_zlen+t,0,0])
                                fingerJoint(UP, 0, 1, t, lid_top_y, 0, lid_back_z, 0);
                            translate([0,lid_top_y+t,0])
                                fingerJoint(RIGHT, 1, 2, t, lid_bezel_io_cover_y+t, 0, bezel_safety_zlen, 0);
                            
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