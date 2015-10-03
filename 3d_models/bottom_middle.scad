// how big the frame itself will be
border_size = 8;

// diameter of the usb extension cable exit
cable_diameter = 5;

// cable offset: where the center of the cable should lie in the piece. this
// seems like a magic number, but it's the total width (275) over 2 (137.5),
// minus the width of left_side_and_bottom (90)
cable_offset = 47.5;

// section size
width = 65;

difference() {
	difference() {
		// main body
		cube([width, border_size * 2, border_size / 2]);

		// curved cut
		translate([cable_offset, cable_diameter / 2, border_size * -0.5]) {
			cylinder(border_size * 1.5, cable_diameter / 2, cable_diameter / 2);
		}
	}

	// square bottom to the curved cut
	translate([cable_offset - cable_diameter / 2, cable_diameter * -0.5, border_size * -0.5]) {
		cube([cable_diameter, cable_diameter, border_size * 1.5]);
	}
}
