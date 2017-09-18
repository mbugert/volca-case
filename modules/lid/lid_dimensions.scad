include <../case_dimensions.scad>

// height of the lid from the bezel top to the top inside the lid
lid_z = max_poti_zlen + poti_safety_zlen;

// zlen of the vertical back part between potis and io jacks
lid_back_z = lid_z - bezel_safety_zlen - t;

// dimensions of the two corners missing from the back of the top lid
power_jack_corner_dims = [power_jack_x, power_jack_y] + (power_jack_r + jack_r_padding)*[1,1];
audio_jack_corner_dims = [midi_jack_x, midi_jack_y] + (midi_jack_r + jack_r_padding)*[1,1];