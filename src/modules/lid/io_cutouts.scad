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

include <lid_dimensions.scad>
include <../case_settings.scad>

module _io_cutouts_2d() {
    dif = 1;

    if (cutouts_for_io_jacks) {
        // power jack
        translate([power_jack_x, -power_jack_y])
            _io_milled_2d(power_jack_y+dif, power_jack_r);

        // midi jack
        translate([x,0] - [midi_jack_x, midi_jack_y])
            _io_milled_2d(midi_jack_y+dif, midi_jack_r);

        // audio jacks
        hull() {
            translate([0,-audio_jacks_y]) {
                for(xi=[0,1,2]) {
                    translate([x,0] - [audio_jacks_x + xi*audio_jacks_spacing_x, 0])
                        _io_milled_2d(audio_jacks_y+dif, audio_jacks_r);
                }
            }
                // put a fourth one in the position of the midi jack: this way, the thin bridge between the midi jack cutout and the leftmost audio jack cutout vanishes            
            translate([x,0] - [midi_jack_x, audio_jacks_y])
                _io_milled_2d(audio_jacks_y+dif, audio_jacks_r);
        }
    }
    
    // panel screws in the back
    if (bezel_safety_zlen < panel_screw_zlen + tol) {
        for (xpos = [panel_screw_x, x-panel_screw_x]) {
            translate([xpos,-panel_screw_back_y])
                circle(r=panel_screw_r + 0.5*jack_r_padding);
        }
    }
}

module _io_milled_2d(mill_y, r) {
    r_pad = r + jack_r_padding;
    circle(r=r_pad);
    translate([-r_pad,0])
        square(r_pad*[2,0] + [0, mill_y + t]);
}

module io_cutouts() {    
    dif=1;
    translate([0,0,-dif])
        linear_extrude(height=t+2*dif)
            _io_cutouts_2d();
}

io_cutouts();