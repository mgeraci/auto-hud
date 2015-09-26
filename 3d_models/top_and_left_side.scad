// ipad dimensions. the wrapper will be bigger than this so it slides in.
ipad_width = 60;
ipad_height = 104;

// how big the frame itself will be
border_size = 8;

// nail hole info
nail_diameter = 4;
nail_angle = 6; // degrees

module nail() {
	translate([border_size, ipad_height + border_size, 2]) {
		rotate([nail_angle, 0, 0]) {
			cylinder(border_size * 2, nail_diameter, nail_diameter);
		}
	}
}

// top edge
difference() {
	translate([0, ipad_height + border_size, 0]) {
		cube([ipad_width + border_size, border_size, border_size * 2]);
	}

	nail();
}

// side
difference() {
	cube([border_size, ipad_height + border_size * 2, border_size * 2]);

	nail();
}


// ridges
/////////////////////////////////////////////////////////////////////////////

difference() {
	translate([0, 0, border_size]) {
		// top
		translate([0, ipad_height, 0]) {
			cube([ipad_width + border_size, border_size * 2, border_size]);
		}

		// side
		cube([border_size * 2, ipad_height + border_size * 2, border_size]);
	}

	nail();
}
