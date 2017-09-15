include <laserscad.scad>
include <lasercut.scad>

include <case_dimensions.scad>

module lid() {
    dif = 1;
    z = max_poti_zlen + poti_safety_zlen;
    
    // ylen of the part covering the io jacks
    bezel_io_cover_y = midi_jack_y + midi_jack_r + jack_r_padding;
    
    // ylen of the raised part above the keyboard and potis (-t because of the vertical lid_back part)
    higher_top_y = y - bezel_io_cover_y - t;  
    
    // zlen of the vertical back part between potis and io jacks
    lid_back_z = max_poti_zlen + poti_safety_zlen - bezel_safety_zlen - t;
    
    lrotate([90,0,0])
        lid_front(z=z);
    
    lrotate([0,-90,0])
        lid_side("lid_left", z=z, lid_back_z=lid_back_z, higher_top_y=higher_top_y, bezel_io_cover_y=bezel_io_cover_y);
    
    ltranslate([x+t,0,0])
        lrotate([0,-90,0])
            lid_side("lid_right", z=z, lid_back_z=lid_back_z, higher_top_y=higher_top_y, bezel_io_cover_y=bezel_io_cover_y);
    
    ltranslate([-t,-t,z])
        lid_top_raised(higher_top_y=higher_top_y);
    
    ltranslate([-t,0,z- lid_back_z -t]) {
        ltranslate([0,higher_top_y+t,0])
            lrotate([90,0,0])
                lid_back(lid_back_z=lid_back_z);

        ltranslate([0,-t + y-bezel_io_cover_y,0])
            bezel_io_cover(bezel_io_cover_y=bezel_io_cover_y, cutouts=cutouts_for_io_jacks);
    }
}

module bezel_io_cover(bezel_io_cover_y=0, cutouts=true) {
    lpart("bezel_io_cover", [x+2*t, bezel_io_cover_y+2*t]) {
        translate([t,t,0])
            difference() {
                lasercutoutSquare(
                    thickness=t,
                    x=x,
                    y=bezel_io_cover_y+t,
                    finger_joints=[
                        [DOWN,0,2],
                        [LEFT,1,2],
                        [RIGHT,0,2]
                    ]);
                translate([0,bezel_io_cover_y,0]) {
                    // IO/power jacks, if desired
                    if (cutouts)
                        jack_cutouts(t, jack_r_padding=jack_r_padding);
                    
//                        // panel screws in the back
//                        for (xpos = [panel_screw_x, x-panel_screw_x]) {
//                            translate([xpos,-panel_screw_back_y,-dif])
//                            cylinder(r=panel_screw_r + 0.5*jack_r_padding, h=t+2*dif);
//                        }
                }
            }
            
        // fix holes in finger joints
        cube(t);
        translate([x+t,0,0])
            cube(t);
    }
}

module jack_cutouts(t, jack_r_padding=0) {   
    dif = 1;
    
    // power jack
    jack_cutout([power_jack_x,-power_jack_y,0], power_jack_y, power_jack_r);

    hull() {
        // midi jack
        jack_cutout([xlen-midi_jack_x, -midi_jack_y,0], midi_jack_y, midi_jack_r);
        
        // audio jacks
        for(xi=[0,1,2]) {
            jack_cutout([xlen-audio_jacks_x-xi*audio_jacks_spacing_x,-audio_jacks_y,0], audio_jacks_y, audio_jacks_r);
        }
    }
    
    module jack_cutout(pos, mill_y, r) {
        r_safe = r + jack_r_padding;
        translate(pos - [0,0,dif]) {
            cylinder(r=r_safe, h=t+2*dif);
            translate([-r_safe,0,0])
                cube(r_safe*[2,0,0] + [0,mill_y+t,t] + dif*[0,1,2]);
        }    
    }
}

module lid_back(lid_back_z=0) {
    lpart("lid_back", [x+2*t, lid_back_z+2*t])
        translate([t,t,0])
            lasercutoutSquare(thickness=t, x=x, y=lid_back_z,
                finger_joints=[
                    [UP,0,6],
                    [DOWN,1,2],
                    [LEFT,0,1],
                    [RIGHT,1,1]
                ]);
}

module lid_top_raised(higher_top_y=0) {
    lpart("lid_top_raised", [x+2*t, higher_top_y+2*t])
        translate([t,t,0]) {            
            lasercutoutSquare(thickness=t, x=x, y=higher_top_y,
                finger_joints=[
                    [DOWN,1,6],
                    [UP,1,6],
                    [LEFT,1,4],
                    [RIGHT,0,4]
                ]);
        }
}


module lid_front(z=0) {
    ltranslate([-t,0,0])
        lpart("lid_front", [x+2*t, z+t])
            translate([t,0,0])
                lasercutoutSquare(thickness=t, x=x, y=z,
                    finger_joints=[
                        [UP,1,6],
                        [LEFT,1,2],
                        [RIGHT,0,2]
                    ]);
}


module lid_side(id, z=0, lid_back_z=0, higher_top_y=0, bezel_io_cover_y=0) {
    dif = 1;
    ltranslate([-case_wave_amplitude,-t,0])
        lpart(id, [case_wave_amplitude+z+t, y+2*t])
            translate([case_wave_amplitude,t,0]) {
                difference() {
                    union() {
                        linear_extrude(height=t) {
                            square([z, higher_top_y]);
                            translate([0,higher_top_y])
                                square([bezel_safety_zlen, bezel_io_cover_y+2*t]);
                        }
                        
                        // all them joints
                        fingerJoint(DOWN, 1, 2, t, 0, 0, z, 0);
                        fingerJoint(RIGHT, 1, 4, t, higher_top_y, 0, z, 0);
                        translate([bezel_safety_zlen+t,0,0])
                            fingerJoint(UP, 1, 1, t, higher_top_y, 0, lid_back_z, 0);
                        translate([0,higher_top_y+t,0])
                            fingerJoint(RIGHT, 1, 2, t, bezel_io_cover_y+t, 0, bezel_safety_zlen, 0);
                        
                        // missing corners for finger joints
                        translate([z,-t,0])
                            cube(t);
                        translate([z,higher_top_y,0])
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