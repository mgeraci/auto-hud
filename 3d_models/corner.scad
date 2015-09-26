// how big the frame will be
border_size = 8;


// edges
/////////////////////////////////////////////////////////////////////////////

// bottom
difference() {
	cube([border_size * 2, border_size, border_size * 2]);
}

// side
cube([border_size, border_size * 2, border_size * 2]);


// ridges
/////////////////////////////////////////////////////////////////////////////

translate([0, 0, border_size]) {
	// bottom
	cube([border_size * 2, border_size * 2, border_size]);

	// side
	cube([border_size * 2, border_size * 2, border_size]);
}
