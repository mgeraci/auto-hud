// frame dimensions. if the mirror is 12"x12" (304.8mm x), we want about 50mm
// of border between the edge of the mirror and the frame.
mirror_width = 404.8; // 304.8 == 12"
mirror_height = 404.8;
padding = 30.8;

frame_width = mirror_width - padding * 2;
frame_height = mirror_height - padding * 2;

// ipad dimensions. the wrapper will be bigger than this so it slides in.
ipad_width = 189.7;
ipad_height = 242.8;

// how big the frame itself will be
border_size = 6;

// the width of the cut-out for the ipad's power cord
cord_size = 20;


// frame
///////////////////////////////////////////////////////////////////////////////

// bottom
cube([frame_width, border_size, border_size * 2]);

// top
translate([0, frame_height - border_size, 0]) {
	cube([frame_width, border_size, border_size * 2]);
}

// left
cube([border_size, frame_height, border_size * 2]);

// right
translate([frame_width - border_size, 0, 0]) {
	cube([border_size, frame_height, border_size * 2]);
}


// ipad holder
///////////////////////////////////////////////////////////////////////////////

translate([padding / 2, padding * 2, 0]) {

	// edges
	/////////////////////////////////////////////////////////////////////////////

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
	/////////////////////////////////////////////////////////////////////////////

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
}
