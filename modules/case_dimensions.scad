include <volca_dimensions.scad>
include <case_settings.scad>


// ############# CASE SETTINGS #############

$fn = 25;
t = thickness;

// extra bit of air between case and volca unit - 0.79 instead of 0.80 because lasercut is buggy with 0.8 and doesn't create all fingers on some parts
tol = 0.79;

// x and y lengths of a volca unit, including tolerance
x = xlen + tol;
y = ylen + tol;

// space between tallest poti and the shell on top
poti_safety_zlen = 4;

// space between the aluminium bezel and the closest part of the shell above it
bezel_safety_zlen = panel_screw_zlen + tol;

// safety pin stuff
safety_pin_inner_xlen = bezel_side_clearance_x - t - 1; // 1 is some arbitrary extra distance to ensure the pin can be inserted/removed
safety_pin_ylen = 12;
safety_pin_center_y = ribbon_ylen + 2*(panel_screw_r) + 9; // place the pin behind the panel screw located behind the ribbon keyboard (9mm is half of the distance between panel screw and the nearest knob on all current volcas (except fm where it doesn't matter))
safety_pin_z = 1; // 1mm above the bezel

// create several variants of the safety pins with different kerf adjustment, in the hopes of finding some that fit nicely
safety_pin_kerf_from = 0;
safety_pin_kerf_to = 2*lkerf;
safety_pin_kerf_variants = 4;

// case wave stuff
case_wave_deg = 540; // three bumps
case_wave_amplitude = safety_pin_z + 2.75*t;
case_wave_wave_length = ylen+tol;
case_wave_k = get_case_wave_k(ylen+tol, safety_pin_center_y);

// center of magnet for bottom and lid sides
//magnet_zy = get_case_wave_pos(case_wave_amplitude, case_wave_wave_length, case_wave_k, 90);
// magnet distance from wave valley in z direction
//magnet_spacing_z = t+0.5*magnet_zlen;

// finger radius for finger hole(s)
finger_radius = 11;

// ##########################################

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