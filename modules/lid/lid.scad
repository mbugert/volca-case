include <laserscad.scad>
include <lasercut.scad>

include <../case_dimensions.scad>
use <unobstructed_back.scad>

module lid() {
    // height of the lid from the bezel top to the top inside the lid
    z = max_poti_zlen + poti_safety_zlen;
    
    // ylen of the part covering the io jacks
    bezel_io_cover_y = midi_jack_y + midi_jack_r + jack_r_padding;
    
    // ylen of the raised part above the keyboard and potis (-t because of the vertical lid_back part)
    top_y = y - bezel_io_cover_y - t;  
    
    // zlen of the vertical back part between potis and io jacks
    lid_back_z = max_poti_zlen + poti_safety_zlen - bezel_safety_zlen - t;
    
    ltranslate([-t,0,0]) {
        lrotate([90,0,0])
            lid_front(z=z);
        
        // for volcas with unobstructed backs (at the time of writing: sample and beats)
        if(is_back_unobstructed) {
            ltranslate([0,-t,z])
                lid_top(top_y=top_y);
            
            ltranslate([0,0,z-t-lid_back_z]) {
                ltranslate([0,top_y+t,0])
                    lrotate([90,0,0])
                        lid_back(lid_back_z=lid_back_z);

                ltranslate([0,-t+y-bezel_io_cover_y,0])
                    bezel_io_cover(bezel_io_cover_y=bezel_io_cover_y);
            }
        } else {
            echo("Currently not supported!");
        }
    }
    
    lid_side("lid_left", z=z, lid_back_z=lid_back_z, top_y=top_y, bezel_io_cover_y=bezel_io_cover_y);
    
    ltranslate([x+t,0,0])
        lid_side("lid_right", z=z, lid_back_z=lid_back_z, top_y=top_y, bezel_io_cover_y=bezel_io_cover_y);
}


module lid_front(z=0) {
    lpart("lid_front", [x+2*t, z+t])
        translate([t,0,0])
            lasercutoutSquare(thickness=t, x=x, y=z,
                finger_joints=[
                    [UP,1,6],
                    [LEFT,1,2],
                    [RIGHT,0,2]
                ]);
}


module lid_side(id, z=0, lid_back_z=0, top_y=0, bezel_io_cover_y=0) {
    dif = 1;
    
    lrotate([0,-90,0])
        ltranslate([-case_wave_amplitude,-t,0])
            lpart(id, [case_wave_amplitude+z+t, y+2*t])
                translate([case_wave_amplitude,t,0]) {
                    difference() {
                        union() {
                            linear_extrude(height=t) {
                                square([z, top_y]);
                                translate([0,top_y])
                                    square([bezel_safety_zlen, bezel_io_cover_y+2*t]);
                            }
                            
                            // all them joints
                            fingerJoint(DOWN, 1, 2, t, 0, 0, z, 0);
                            fingerJoint(RIGHT, 1, 4, t, top_y, 0, z, 0);
                            translate([bezel_safety_zlen+t,0,0])
                                fingerJoint(UP, 1, 1, t, top_y, 0, lid_back_z, 0);
                            translate([0,top_y+t,0])
                                fingerJoint(RIGHT, 1, 2, t, bezel_io_cover_y+t, 0, bezel_safety_zlen, 0);
                            
                            // missing corners for finger joints
                            translate([z,-t,0])
                                cube(t);
                            translate([z,top_y,0])
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