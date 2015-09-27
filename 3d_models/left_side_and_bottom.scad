// maximum print size
max = 120;

// distance from the edge to the cable port on the ipad
width = 82;

// distance from the bottom of the last piece to the edge of the ipad
height = 12;

// distance from the bottom of the ipad to the corner of the mirror
x_height = 15;

// how big the frame itself will be
border_size = 8;

cord_size = 30;


// sides
/////////////////////////////////////////////////////////////////////////////

// side
translate([width, 0, 0]) {
	cube([border_size, height + border_size, border_size * 2]);
}

// ipad bottom holder: left
cube([width + border_size, border_size, border_size * 2]);


// ridges
/////////////////////////////////////////////////////////////////////////////

// side
translate([width - border_size, 0, 0]) {
	cube([border_size * 2, height + border_size, border_size]);
}

// ipad bottom holder: left
cube([width + border_size, border_size * 2, border_size]);


// bottom structure
/////////////////////////////////////////////////////////////////////////////

translate([0, x_height * -1, 0]) {
	// left
	translate([width + border_size / 2, 0, 0]) {
		cube([border_size / 2, x_height, border_size * 2]);
	}

	// bottom
	cube([width + border_size, border_size / 2, border_size * 2]);

	// right (internal wall)
	cube([border_size / 2, x_height, border_size * 2]);
}
