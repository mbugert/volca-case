include <case_dimensions.scad>

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