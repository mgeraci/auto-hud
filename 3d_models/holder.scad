ipad_width = 300;
ipad_height = 500;
border_size = 10;
ipad_outer_width = ipad_width + border_size * 2;
ipad_outer_height = ipad_height + border_size * 2;


// edges
///////////////////////////////////////////////////////////////////////////////

// top edge
cube([ipad_outer_width, border_size, border_size * 2]);

// bottom edge
translate([0, ipad_height + border_size, 0]) {
	cube([ipad_outer_width, border_size, border_size * 2]);
}

// side
cube([border_size, ipad_outer_height, border_size * 2]);


// ridges
///////////////////////////////////////////////////////////////////////////////

translate([0, 0, border_size]) {
	// top
	cube([ipad_outer_width, border_size * 2, border_size]);

	// bottom
	translate([0, ipad_height, 0]) {
		cube([ipad_outer_width, border_size * 2, border_size]);
	}

	// side
	cube([border_size * 2, ipad_outer_height, border_size]);
}
