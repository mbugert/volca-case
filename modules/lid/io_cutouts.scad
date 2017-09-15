include <../case_dimensions.scad>

module io_cutouts(t=1) {   
    dif = 1;
    
    // power jack
    io_cutout([power_jack_x,-power_jack_y,0], power_jack_y, power_jack_r);

    hull() {
        // midi jack
        io_cutout([xlen-midi_jack_x, -midi_jack_y,0], midi_jack_y, midi_jack_r);
        
        // audio jacks
        for(xi=[0,1,2]) {
            io_cutout([xlen-audio_jacks_x-xi*audio_jacks_spacing_x,-audio_jacks_y,0], audio_jacks_y, audio_jacks_r);
        }
    }
    
    module io_cutout(pos, mill_y, r) {
        r_safe = r + jack_r_padding;
        translate(pos - [0,0,dif]) {
            cylinder(r=r_safe, h=t+2*dif);
            translate([-r_safe,0,0])
                cube(r_safe*[2,0,0] + [0,mill_y+t,t] + dif*[0,1,2]);
        }    
    }
}

io_cutouts();