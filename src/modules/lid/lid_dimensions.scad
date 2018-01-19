// Copyright 2018, mbugert
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

include <../case_dimensions.scad>

// height of the lid from the bezel top to the top inside the lid
lid_z = max_poti_zlen + poti_safety_zlen;

// zlen of the vertical back part between potis and io jacks
lid_back_z = lid_z - bezel_safety_zlen - t;

// dimensions of the two corners missing from the back of the top lid
power_jack_corner_dims = [power_jack_x, power_jack_y] + (power_jack_r + jack_r_padding)*[1,1];
audio_jack_corner_dims = [midi_jack_x, midi_jack_y] + (midi_jack_r + jack_r_padding)*[1,1];