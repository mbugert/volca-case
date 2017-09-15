include <laserscad.scad>
include <lasercut.scad>

include <case_dimensions.scad>
include <safety_pin.scad>


module bottom_case() {
    dif = 1;
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
    
    ltranslate([0,0,-zlen-rubber_feet_zlen]) {
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
            
    ltranslate([0,safety_pin_center_y,safety_pin_z]) {
        safety_pin("safety_pin_left");
        ltranslate([x,0,0])
            lrotate([0,0,180])
                safety_pin("safety_pin_right");
    }
}

bottom_case();