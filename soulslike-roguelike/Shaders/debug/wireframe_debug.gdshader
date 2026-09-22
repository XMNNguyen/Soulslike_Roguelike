shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, unshaded;

uniform vec4 wire_color : source_color = vec4(0.0, 1.0, 0.0, 1.0); // Neon Green default
uniform float line_thickness : hint_range(0.0, 0.1) = 0.02;

varying vec3 v_barycentric;

void vertex() {
	// assign barycentric coordinates for each vertex
	int index = VERTEX_ID % 3;
	
	if (index == 0) {
		v_barycentric = vec3(1.0, 0.0, 0.0);
	} else if (index == 1) {
		v_barycentric = vec3(0.0, 1.0, 0.0);
	} else {
		v_barycentric = vec3(0.0, 0.0, 1.0);
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
	// get closest vertex and assign pixel color accordingly
	float min_barycentric = min(min(v_barycentric.x, v_barycentric.y), v_barycentric.z);
	
	if (min_barycentric < line_thickness) {
		ALBEDO = wire_color.rgb;
	} else {
		discard;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
