// ############### SETTINGS #################

// CHOOSE YOUR FLAVOR:
// 0: one size fits all
// 1: beats
// 2: bass
// 3: keys
// 4: sample
// 5: fm
// 6: kick
unit = 0;

// leave holes in the lid for power, MIDI and audio jacks? (so that the lid can be put on without having to unplug everything)
cutouts_for_io_jacks = true;

// create holes for magnets which hold the lid in place?
//cutouts_for_magnetic_lid = false;

// magnet dimensions in millimeters - magnet_xlen is assumed to be equal to the shell thickness, i.e. use 5mm wide magnets if you set thickness to 5mm
//magnet_ylen = 5;
//magnet_zlen = 2;

// engrave the name of the unit on the lid (and more)?
engravings = true;

// engrave the values of the most important settings into the bottom of the base? (useful when experimenting with parameters)
debug_engravings = false;

// safety distance between jacks and case in millimeters - increase this if you use cables with bulky plugs
jack_r_padding = 1.5;

// sheet thickness in millimeters (5mm max due to the MIDI jack and neighboring potis; maybe 6mm if you own a MIDI cable with a very slim plug)
thickness = 3;

// laser kerf compensation in millimeters
lkerf = 0.05; // 2.5mm PMMA in Epilog Zing with 25% speed, 50% power, 5000Hz laser

// separation of parts in 2D in millimeters
lmargin = 2;

// don't engrave parts with their ID
lidentify = false;