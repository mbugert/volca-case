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

// add line-art engravings on the lid (if available) and the name of the unit on the bottom (and more)?
engravings = true;

// engrave the values of the most important settings into the bottom of the base? (useful when experimenting with parameters; also generated when engravings = false)
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