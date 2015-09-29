height = 120;

// how big the frame itself will be
border_size = 8;

difference() {
	cube([border_size, height, border_size * 2]);

	translate([border_size * -1, border_size * -2, border_size * 1]) {
		cube([border_size * 3, border_size * 3, border_size * 3]);
	}
}
