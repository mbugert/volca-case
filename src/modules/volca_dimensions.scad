// ######### KORG VOLCA DIMENSIONS ##########

xlen = 193;
ylen = 115;
zlen = 29; // bottom to bezel

// TODO measured from a modified device!
rubber_feet_zlen = 2;

// for the area between the two panel screws: clearance on the x axis between the device edge and the closest poti
bezel_side_clearance_x = 8;

midi_jack_x = 62; // measured from the right (xmax)
midi_jack_y = 17; // measured from the back (ymax)
midi_jack_r = 8.5;

audio_jacks_x = 20; // measured from the right (xmax)
audio_jacks_y = 14; // measured from the back (ymax)
audio_jacks_spacing_x = 12;
audio_jacks_r = 4;

power_jack_x = 30; // measured from the left (xmin)
power_jack_y = 13; // measured from the back (ymax)
power_jack_r = 5;

power_button_zlen = 1;

panel_screw_zlen = 3;
panel_screw_r = 2.5;
panel_screw_x = 4 + panel_screw_r; // measured from either side (xmin, xmax)
panel_screw_back_y = 5 + panel_screw_r; // measured from the back (ymax)

small_poti_zlen = 10;
medium_poti_zlen = 15;  // bass/treble poti on sample
large_poti_zlen = 18; // cutoff poti on bass (TODO educated guess!)

onerow_ribbon_ylen = 40;
tworow_ribbon_ylen = 55; // TODO educated guess!


// #### DIMENSIONS DEPENDING ON THE UNIT ####

// order applying to all lists:
// 0: one size fits all
// 1: beats
// 2: bass
// 3: keys
// 4: sample
// 5: fm
// 6: kick
names_by_unit = ["", "beats", "bass", "keys", "sample", "fm", "kick"];
max_poti_zlen_by_unit = [large_poti_zlen, medium_poti_zlen, large_poti_zlen, medium_poti_zlen, medium_poti_zlen, small_poti_zlen, large_poti_zlen];
ribbon_ylen_by_unit = [onerow_ribbon_ylen, onerow_ribbon_ylen, onerow_ribbon_ylen, tworow_ribbon_ylen, onerow_ribbon_ylen, tworow_ribbon_ylen, onerow_ribbon_ylen];
// if the area between the power and the MIDI jack is free
free_back_by_unit = [false, true, false, false, true, false, false];

unit = -1;
name = names_by_unit[unit];
max_poti_zlen = max_poti_zlen_by_unit[unit];
ribbon_ylen = ribbon_ylen_by_unit[unit];
is_back_free = free_back_by_unit[unit];