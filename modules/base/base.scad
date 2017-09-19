include <laserscad.scad>
include <lasercut.scad>

include <base_dimensions.scad>
use <safety_pin.scad>


module base_side(id) {
    dif=1;
    x = base_z;
    
    ltranslate([t,0,0])
        lrotate([0,-90,0])
            lpart(id, [x+t+case_wave_amplitude, y+2*t])
                translate([t,t,0]) {
                    difference() {
                        union() {
                            linear_extrude(height=t)
                                square([base_z, y]);
                            
                            // all the joints
                            fingerJoint(UP, 0, 2, t, y, 0, x, 0);
                            fingerJoint(DOWN, 1, 2, t, y, 0, x, 0);
                            fingerJoint(LEFT, 0, 4, t, y, 0, x, 0);
                        }
                        
                        // remove the two bumps which belong to the lid
                        translate([x,0,-dif])
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
                    translate([x,0,0])
                        difference() {
                            linear_extrude(height=t)
                                case_wave(true);
                            translate([safety_pin_z, safety_pin_center_y,0])
                                rotate([0,90,0])
                                    safety_pin_cutout();
                        }
                }
}

module base_front_back(id, back) {
    dif=1;
    z_conditional = back? base_z+bezel_safety_zlen : base_z;
    
    ltranslate([0,t,0])
        lrotate([90,0,0])
            lpart(id, [x+2*t, z_conditional+t]) {
                translate([t,t,0]) {
                    difference() {
                        lasercutoutSquare(thickness=t, x=x, y=z_conditional,
                            finger_joints=[
                                [DOWN,1,6]
                            ]);
                        
                        // if this is the front, create a finger hole
                        if (!back) {
                            translate([x/2, base_z, -dif])
                                cylinder(r=finger_radius, h=t+2*dif);
                        }
                    }
                    fingerJoint(LEFT, 1, 2, t, base_z, 0, x, 0);
                    fingerJoint(RIGHT, 0, 2, t, base_z, 0, x, 0);
                }
                
                // fix missing corners in finger joints
                cube(t);
                translate([x+t,0,0])
                    cube(t);
            }
}

module base_bottom() {
    lpart("base_bottom", [x+2*t, y+2*t])
        translate([t,t,0])
            lasercutoutSquare(thickness=t, x=x, y=y,
                finger_joints=[
                    [UP,1,6],
                    [DOWN,0,6],
                    [LEFT,1,4],
                    [RIGHT,0,4]
                ]);
}

// create variants of the safety pins with different kerf
module safety_pin_variants() {
    eps = 0.0001;
    
    for (i = [0:1:safety_pin_kerf_variants-1]) {
        // make sure to subtract the global lkerf
        kerf_delta = safety_pin_kerf_from + i/safety_pin_kerf_variants * (safety_pin_kerf_to - safety_pin_kerf_from) - lkerf;
        
        // no need to laser the safety pin with global kerf another time, so skip it
        if (abs(kerf_delta - lkerf) > eps) {
            ltranslate([0, i*(safety_pin_ylen+t),0]) {
                safety_pin(str("left_", kerf_delta), kerf_delta=kerf_delta);
                ltranslate([safety_pin_inner_xlen+2*t,0,0])
                    safety_pin(str("right_", kerf_delta), kerf_delta=kerf_delta);
            }
        }
    }
}

module base() {   
    ltranslate([0,0,-base_z] - t*[1,1,1]) {
        base_bottom();
        base_side("base_left");
    
        ltranslate([x+t,0,0])
            base_side("base_right");

        base_front_back("base_front", false);
        
        ltranslate([0,y+t,0])
            base_front_back("base_back", true);
    }
    
    // safety pins with the same kerf as the whole case
    ltranslate([0,safety_pin_center_y,safety_pin_z]) {
        safety_pin("left");
        ltranslate([x,0,0])
            lrotate([0,0,180])
                safety_pin("right");
    }
    
    // safety pin variants somewhere off to the side
    ltranslate([x+3*t, 0, -base_z-t]) {
        safety_pin_variants();
    }
}

base();