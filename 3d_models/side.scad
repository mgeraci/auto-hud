// ipad dimensions. the wrapper will be bigger than this so it slides in.
ipad_width = 60;
ipad_height = 104;

// how big the frame itself will be
border_size = 8;

// nail hole info
nail_diameter = 4;
nail_angle = 6; // degrees


// side
cube([border_size, ipad_height + border_size * 2, border_size * 2]);

// ridge
translate([0, 0, border_size]) {
	cube([border_size * 2, ipad_height + border_size * 2, border_size]);
}
