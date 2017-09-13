// ############### LIBRARIES ################

include <korg_volca_dimensions.scad>
include <lasercut.scad>
include <laserscad.scad>

// ############### SETTINGS #################

// CHOOSE YOUR FLAVOR:
// 0: one size fits all (currently not supported)
// 1: beats
// 2: bass (currently not supported)
// 3: keys (currently not supported)
// 4: sample
// 5: fm (currently not supported)
// 6: kick (currently not supported)
unit = 4;

// leave holes in the lid for power, MIDI and audio jacks? (so that the lid can be put on without having to unplug everything)
cutouts_for_io_jacks = true;

// create holes for magnets which hold the lid in place?
cutouts_for_magnetic_lid = false;

// magnet dimensions in millimeters - magnet_xlen is assumed to be equal to the shell thickness, i.e. use 5mm wide magnets if you set thickness to 5mm
magnet_ylen = 5;
magnet_zlen = 2;

// safety distance between jacks and case in millimeters - increase this if you use cables with bulky plugs
jack_r_padding = 1.5;

// sheet thickness in millimeters (5mm max due to the MIDI jack and neighboring potis; maybe 6mm if you own a MIDI cable with a very slim plug)
thickness = 3;

// laser kerf compensation in millimeters
lkerf = 0.05; // 3mm PMMA in Epilog Zing with 25% speed, 50% power, 5000Hz laser

// separation of parts in 2D in millimeters
lmargin = 2;

// in case the material you laser from has a distinguishable top/bottom side, mirror the following lparts: bottom_case_right, bottom_case_back, bottom_case_bottom, lid_right, lid_back

// ############# BOX SETTINGS ##############

// utility variables
$fn = 100;
dif = 1;
alpha = 0.8;
tol = 0.79; // extra bit of air between case and volca unit - 0.79 instead of 0.80 because lasercut bugs with 0.8 and doesn't create all fingers on some parts
t = thickness;

// space between tallest poti and the shell on top
poti_safety_zlen = 4;

// space between the aluminium bezel and the closest part of the shell above it
bezel_safety_zlen = panel_screw_zlen + tol;

// safety pin stuff
safety_pin_inner_xlen = resting_border_inner_xlen - t - 1; // 1 is some arbitrary extra distance to ensure the pin can be inserted/removed
safety_pin_ylen = 12;
safety_pin_center_y = ribbon_ylen + 2*(panel_screw_r) + 9; // place the pin behind the panel screw located behind the ribbon keyboard (9mm is half of the distance between panel screw and the nearest knob on all current volcas (except fm where it doesn't matter))
safety_pin_z = 1; // 1mm above the bezel

// case wave stuff
case_wave_deg = 540; // three bumps
case_wave_amplitude = safety_pin_z + 2.75*t;
case_wave_wave_length = ylen+tol;
case_wave_k = get_case_wave_k(ylen+tol, safety_pin_center_y);

// center of magnet for bottom and lid sides
magnet_zy = get_case_wave_pos(case_wave_amplitude, case_wave_wave_length, case_wave_k, 90);
// magnet distance from wave valley in z direction
magnet_spacing_z = t+0.5*magnet_zlen;

// finger radius for finger hole(s)
finger_radius = 11;

// ##########################################

// sanity checks
if (safety_pin_inner_xlen < 0) {
    echo("WARNING: Thickness too high for removable safety pins.");
}
if (!is_back_unobstructed) {
    echo(str("WARNING: A case for volca ", name, " is currently not supported!"));
}

module safety_pin(id) {
    x = safety_pin_inner_xlen;
    y = safety_pin_ylen;

    ltranslate([-t, -0.5*y, 0])
        lpart(id, [x+t,y])
            translate([t,0,0]) {
                cube([x, y, t]);
                fingerJoint(LEFT, 1, 2, t, 4/3 * y, 0, x, 0, true);
            }
}
module safety_pin_cutout() {
    x = safety_pin_inner_xlen;
    y = safety_pin_ylen;
    
    translate([-dif,-0.5*y,0])
        fingerJoint(LEFT, 1, 2, t, 4/3 * y, 0, x, 0, false);
}


// exponent k is chosen so that the 270° bump coincides with the fixpoint
function get_case_wave_k(wave_length, fixpoint_y) = (log(fixpoint_y) - log(wave_length)) / log(270/case_wave_deg);

function get_case_wave_pos(a, l, k, deg) = [-a*sin(deg), l*pow(deg/case_wave_deg, k)];

module case_wave(positive_part) {
    intersection() {
        if (positive_part) {
            square([case_wave_amplitude, case_wave_wave_length]);
        } else {
            translate([-case_wave_amplitude,0,0])
                square([case_wave_amplitude, case_wave_wave_length]);
        }
        
        a = case_wave_amplitude;
        l = case_wave_wave_length;
        k = case_wave_k;
        deg = case_wave_deg;
        rotate([0,0,90])
            polygon([for (i = [0:$fn]) [l*pow(i/$fn, k), a*sin(deg*i/$fn)]]); 
    }
}

module bottom_case() {
    x = xlen + tol;
    y = ylen + tol;
    z = zlen + rubber_feet_zlen;
    
    module bottom_case_side(id) {
        ltranslate([-t,-t,0])
            lpart(id, [z+t+case_wave_amplitude, y+2*t])
                translate([t,t,0]) {
                    difference() {
                        union() {
                            linear_extrude(height=t)
                                square([z, y]);
                            
                            // all the joints
                            fingerJoint(UP, 0, 2, t, y, 0, z, 0);
                            fingerJoint(DOWN, 1, 2, t, y, 0, z, 0);
                            fingerJoint(LEFT, 0, 4, t, y, 0, z, 0);
                        }
                        
                        // remove the two bumps which belong to the lid
                        translate([z,0,-dif])
                            linear_extrude(height=t+2*dif) {
                                case_wave(false);
                                square([dif, y]); // to ensure valid 2-manifold
//                                if (cutouts_for_magnetic_lid) {
//                                    translate(magnet_zy - [magnet_spacing_z, 0]) {
//                                        square([magnet_zlen, magnet_ylen], center=true);
//                                    }
//                                }
                            }
                    }
                    
                    // add the middle bump of the wave and create cutouts for the safety pin
                    translate([z,0,0])
                        difference() {
                            linear_extrude(height=t)
                                case_wave(true);
                            translate([safety_pin_z, safety_pin_center_y,0])
                                rotate([0,90,0])
                                    safety_pin_cutout();
                        }
                }
    }
    
    module bottom_case_front_back(id, back) {
        z_conditional = back? z+bezel_safety_zlen : z;
        ltranslate([-t,-t,0])
            lpart(id, [x+2*t, z_conditional+t]) {
                translate([t,t,0]) {
                    difference() {
                        lasercutoutSquare(thickness=t, x=x, y=z_conditional,
                            finger_joints=[
                                [DOWN,1,6]
                            ]);
                        
                        // if this is the front, create a finger hole
                        if (!back) {
                            translate([x/2, z, -dif])
                                cylinder(r=finger_radius, h=t+2*dif);
                        }
                    }
                    fingerJoint(LEFT, 1, 2, t, z, 0, x, 0);
                    fingerJoint(RIGHT, 0, 2, t, z, 0, x, 0);
                }
                cube(t);
                translate([x+t,0,0])
                    cube(t);
            }
    }
    
    ltranslate(-t*[1,1,1])
        lpart("bottom_case_bottom", [x+2*t, y+2*t])
            translate([t,t,0])
                lasercutoutSquare(thickness=t, x=x, y=y,
                    finger_joints=[
                        [UP,1,6],
                        [DOWN,0,6],
                        [LEFT,1,4],
                        [RIGHT,0,4]
                    ]);
    
    lrotate([0,-90,0])
        bottom_case_side("bottom_case_left");

    ltranslate([x+t,0,0])
        lrotate([0,-90,0])
            bottom_case_side("bottom_case_right");

    lrotate([90,0,0])
        bottom_case_front_back("bottom_case_front", false);

    ltranslate([0,y+t,0])
        lrotate([90,0,0])
            bottom_case_front_back("bottom_case_back", true);
}


module lid() {
    x = xlen + tol;
    y = ylen + tol;
    z = max_poti_zlen + poti_safety_zlen;
    
    // ylen of the part covering the io jacks
    lower_top_y = midi_jack_y + midi_jack_r + jack_r_padding;
    
    // ylen of the raised part above the keyboard and potis (-t because of the vertical lid_back part)
    higher_top_y = y - lower_top_y - t;
    
    // zlen of the vertical back part between potis and io jacks
    lid_back_z = max_poti_zlen + poti_safety_zlen - bezel_safety_zlen - t;
    
    module lid_side(id) {
        ltranslate([-case_wave_amplitude,-t,0])
            lpart(id, [case_wave_amplitude+z+t, y+2*t])
                translate([case_wave_amplitude,t,0]) {
                    difference() {
                        union() {
                            linear_extrude(height=t) {
                                square([z, higher_top_y]);
                                translate([0,higher_top_y])
                                    square([bezel_safety_zlen, lower_top_y+2*t]);
                            }
                            
                            // all them joints
                            fingerJoint(DOWN, 1, 2, t, 0, 0, z, 0);
                            fingerJoint(RIGHT, 1, 4, t, higher_top_y, 0, z, 0);
                            translate([bezel_safety_zlen+t,0,0])
                                fingerJoint(UP, 1, 1, t, higher_top_y, 0, lid_back_z, 0);
                            translate([0,higher_top_y+t,0])
                                fingerJoint(RIGHT, 1, 2, t, lower_top_y+t, 0, bezel_safety_zlen, 0);
                            
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
    
    lrotate([90,0,0])
        ltranslate([-t,0,0])
            lpart("lid_front", [x+2*t, z+t])
                translate([t,0,0])
                    lasercutoutSquare(thickness=t, x=x, y=z,
                        finger_joints=[
                            [UP,1,6],
                            [LEFT,1,2],
                            [RIGHT,0,2]
                        ]);
    
    lrotate([0,-90,0])
        lid_side("lid_left");
    
    ltranslate([xlen+t+tol,0,0])
        lrotate([0,-90,0])
            lid_side("lid_right");
    
    ltranslate([-t,-t,z])
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
    
    ltranslate([0,0,z- lid_back_z -t]) {
        ltranslate([-t,higher_top_y+t,0])
            lrotate([90,0,0])
                lpart("lid_back", [x+2*t, lid_back_z+2*t])
                    translate([t,t,0])
                        lasercutoutSquare(thickness=t, x=x, y=lid_back_z,
                            finger_joints=[
                                [UP,0,6],
                                [DOWN,1,2],
                                [LEFT,0,1],
                                [RIGHT,1,1]
                            ]);
        
        ltranslate([-t,-t + y-lower_top_y,0])
            lpart("lid_lower_back", [x+2*t, lower_top_y+2*t]) {
                translate([t,t,0])
                    difference() {
                        lasercutoutSquare(
                            thickness=t,
                            x=x,
                            y=lower_top_y+t,
                            finger_joints=[
                                [DOWN,0,2],
                                [LEFT,1,2],
                                [RIGHT,0,2]
                            ]);
                        translate([0,lower_top_y,0]) {
                            // IO/power jacks, if desired
                            if (cutouts_for_io_jacks)
                                jack_cutouts();
                            
//                            // panel screws in the back
//                            for (xpos = [panel_screw_x, xlen+tol-panel_screw_x]) {
//                                translate([xpos,-panel_screw_back_y,-dif])
//                                cylinder(r=panel_screw_r + 0.5*jack_r_padding, h=t+2*dif);
//                            }
                        }
                    }
                    
                // fix holes in finger joints
                cube(t);
                translate([x+t,0,0])
                    cube(t);
            }
    }
}

module jack_cutouts() {
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

module full_case() {
    ltranslate([0,0,-zlen-rubber_feet_zlen])  
        color("aqua", alpha)
            bottom_case();
    
    color("lightsalmon", alpha)
        lid();
    
    ltranslate([0,safety_pin_center_y,safety_pin_z]) {
        safety_pin("safety_pin_left");
        ltranslate([xlen+tol,0,0])
            lrotate([0,0,180])
                safety_pin("safety_pin_right");
    }
}

ldummy() volca();
full_case();