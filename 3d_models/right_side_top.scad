// piece dimensions
width = 60;
height = 120;

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

translate([width * -1, 0, 0]) {
	difference() {
		translate([width, height * -1 + border_size, 0]) {
			cube([border_size, height, border_size]);

			translate([0, 0, border_size]){
				cube([border_size, height - border_size, border_size]);
			}
		}

		nail();
	}
}
