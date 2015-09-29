// outer width of the whole piece
width = 120;

// distance from the bottom of the last piece to the edge of the ipad
height = 12;

// distance from the bottom of the ipad to the corner of the mirror
x_height = 15;

// dimensions of the ipad support
ipad_width = 47;

// how big the frame itself will be
border_size = 8;


// ipad holder
/////////////////////////////////////////////////////////////////////////////

cube([ipad_width, border_size, border_size]);


// connections from the ipad holder to the bottom
/////////////////////////////////////////////////////////////////////////////

module connection() {
	cube([ipad_width, x_height, border_size / 2]);
}

translate([0,  x_height * -1, 0]) {
	connection();
}



// bottom structure
/////////////////////////////////////////////////////////////////////////////

translate([0, x_height * -1, 0]) {
	// right top (extends far)
	translate([width - border_size, 0, border_size]) {
		cube([border_size, x_height, border_size]);
	}

	// right bottom (extends less far)
	translate([width - border_size, 0, 0]) {
		cube([border_size, x_height - border_size, border_size]);
	}

	// bottom
	cube([width, border_size / 2, border_size * 2]);
}
