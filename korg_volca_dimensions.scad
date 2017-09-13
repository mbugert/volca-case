// ########### DEVICE DIMENSIONS ############

xlen = 193;
ylen = 115;
zlen = 29; // bottom to bezel

rubber_feet_zlen = 2; // modified! other people's volcas will be different

resting_border_xlen = 4; // distance between device border and the closest panel element - this is what the shell rests on (at least when printing with supports)
resting_border_inner_xlen = 8; // resting border past the panel screws
resting_border_ylen = 5; // at ymax

midi_jack_x = 62; // from xmax
midi_jack_y = 17; // from ymax
midi_jack_r = 8.5;

audio_jacks_x = 20; // from xmax
audio_jacks_y = 14; // from ymax
audio_jacks_spacing_x = 12;
audio_jacks_r = 4;

power_jack_x = 30; // from xmin
power_jack_y = 13; // from ymax
power_jack_r = 5;

panel_screw_zlen = 3;
panel_screw_r = 2.5;
panel_screw_x = 4 + panel_screw_r; // from either side
panel_screw_back_y = 5 + panel_screw_r; // from ymax

power_button_zlen = 1; // roughly

small_poti_zlen = 10;
medium_poti_zlen = 15;  // bass/treble poti on sample
large_poti_zlen = 18; // cutoff poti on bass (educated guess!)

onerow_ribbon_ylen = 40;
tworow_ribbon_ylen = 55; // educated guess!

// #### DIMENSIONS DEPENDING ON THE UNIT ####

// 0: one size fits all
// 1: beats
// 2: bass
// 3: keys
// 4: sample
// 5: fm
// 6: kick
unit = 4;

names_by_unit = ["one_size_fits_all", "beats", "bass", "keys", "sample", "fm", "kick"];
name = names_by_unit[unit];

// in the order: one_size_fits_all, beats, bass, keys, sample, fm, kick
max_poti_zlen_by_unit = [large_poti_zlen, medium_poti_zlen, large_poti_zlen, medium_poti_zlen, medium_poti_zlen, small_poti_zlen, large_poti_zlen];
max_poti_zlen = max_poti_zlen_by_unit[unit];

// in the order: one_size_fits_all, beats, bass, keys, sample, fm, kick
ribbon_ylen_by_unit = [onerow_ribbon_ylen, onerow_ribbon_ylen, onerow_ribbon_ylen, tworow_ribbon_ylen, onerow_ribbon_ylen, tworow_ribbon_ylen, onerow_ribbon_ylen];
ribbon_ylen = ribbon_ylen_by_unit[unit];

// if the area between the power and the MIDI jack is unobstructed
unobstructed_back_by_unit = [false, true, false, false, true, false, false];
is_back_unobstructed = unobstructed_back_by_unit[unit];