// ipad dimensions. the wrapper will be bigger than this so it slides in.
width = 60;

// how big the frame itself will be
border_size = 8;

// nail hole info
nail_diameter = 4;
nail_angle = 6; // degrees

module nail() {
	translate([width, border_size, 2]) {
		rotate([nail_angle, 0, 0]) {
			cylinder(border_size * 2, nail_diameter, nail_diameter);
		}
	}
}

// top edge
difference() {
	translate([0, border_size, 0]) {
		cube([width + border_size, border_size, border_size * 2]);
	}

	nail();
}


// top ridge
difference() {
	translate([0, 0, border_size]) {
		translate([0, 0, 0]) {
			cube([width + border_size, border_size * 2, border_size]);
		}
	}

	nail();
}
