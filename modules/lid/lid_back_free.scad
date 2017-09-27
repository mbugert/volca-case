include <laserscad.scad>
include <lasercut.scad>

use <../engravings.scad>
include <lid_dimensions.scad>
use <io_cutouts.scad>

module bezel_io_cover() {
    y = audio_jack_corner_dims[1];
    lpart("bezel_io_cover", [x+2*t, y+2*t]) {
        translate([t,t,0])
            difference() {
                lasercutoutSquare(
                    thickness=t,
                    x=x,
                    y=y+t,
                    finger_joints=[
                        [DOWN,1,4],
                        [LEFT,1,2],
                        [RIGHT,0,2]
                    ]);
                translate([0,y,0])
                    io_cutouts(t=t);
            }
    }
}


module lid_back() {
    lpart("lid_back", [x+2*t, lid_back_z+2*t])
        translate([t,t,0]) {
            lasercutoutSquare(thickness=t, x=x, y=lid_back_z,
                finger_joints=[
                    [UP,0,6],
                    [DOWN,0,4],
                    [LEFT,1,1],
                    [RIGHT,0,1]
                ]);
            translate([x,lid_back_z,0])
                cube(t);
        }
}

module lid_top() {
    // ylen of the raised part above the keyboard and potis (-t because of the vertical lid_back part)
    y = y - audio_jack_corner_dims[1] - t;
    
    lpart("lid_top", [x+2*t, y+2*t])
        translate([t,t,0]) {       
            lasercutoutSquare(thickness=t, x=x, y=y,
                finger_joints=[
                    [DOWN,1,6],
                    [UP,1,6],
                    [LEFT,0,4],
                    [RIGHT,1,4]
                ]);
            // fix hole caused by joints
            translate([-t,y,0])
                cube(t);
            
            if (engravings)
                lengrave(parent_thick=t)
                    engraving_brand();
        }
}

module lid_back_free() {
    ltranslate([0,-t,lid_z])
        lid_top();

    ltranslate([0,y-audio_jack_corner_dims[1],bezel_safety_zlen]) {
        lrotate([90,0,0])
            lid_back();
        ltranslate([0,-t,0])
            bezel_io_cover();
    }
}

lid_back_free();