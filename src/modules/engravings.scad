include <volca_dimensions.scad>
include <case_dimensions.scad>

// the following order applies:
// 0: one size fits all
// 1: beats
// 2: bass
// 3: keys
// 4: sample
// 5: fm
// 6: kick
line_art_available_by_unit = [false, false, true, false, true, false, false];
line_art = line_art_available_by_unit[unit];

module engraving_line_art(path_prefix) {
    if (line_art) {
        resize([x,y])
            import(str(path_prefix, "../img/", name, ".dxf"));
    } else {
        engraving_brand();
    }
}

module engraving_brand() {
    translate(engraving_brand_margin*[1,1,0])
        _topdown_text(str("volca ", name));
}

module engraving_debug() {
    variables = [lkerf, thickness, jack_r_padding, unit];
    variable_names = ["lkerf", "thickness", "jack_r_padding", "unit"];
    line_sep = 1.2*engraving_font_size;
    
    translate([engraving_brand_margin,-len(variables)*line_sep,0]) {
        for (i=[0:1:len(variables)-1]) {
            translate([0, i*line_sep, 0])
                _topdown_text(str(variable_names[i], " = ", variables[i]), size=0.9*engraving_font_size);
        }
    }
}

module engraving_contact() {
    translate(engraving_brand_margin*[1,1,0])
        _topdown_text("github.com/mbugert/volca-case");
}

module _topdown_text(t, size=engraving_font_size) {
    text(t, size=size, center=false, font=font, spacing=0.9, $fn=10);
}