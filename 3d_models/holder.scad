ipad_width = 300;
ipad_height = 500;

border_size = 10;

cord_size = 20;


// edges
///////////////////////////////////////////////////////////////////////////////

// bottom edge, with cord cut-out
difference() {
	cube([ipad_width + border_size, border_size, border_size * 2]);

	translate([(ipad_width - cord_size) / 2 + border_size, border_size * -1, border_size * -1]) {
		cube([cord_size, border_size * 3, border_size * 2]);
	}
}

// top edge
translate([0, ipad_height + border_size, 0]) {
	cube([ipad_width + border_size, border_size, border_size * 2]);
}

// side
cube([border_size, ipad_height + border_size * 2, border_size * 2]);


// ridges
///////////////////////////////////////////////////////////////////////////////

translate([0, 0, border_size]) {
	// top
	cube([ipad_width + border_size, border_size * 2, border_size]);

	// bottom
	translate([0, ipad_height, 0]) {
		cube([ipad_width + border_size, border_size * 2, border_size]);
	}

	// side
	cube([border_size * 2, ipad_height + border_size * 2, border_size]);
}
