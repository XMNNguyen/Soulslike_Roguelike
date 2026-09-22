shader_type spatial;

/*
	Debug Shader
	Displays mesh as a black and white checkerboard
*/

uniform float scale : hint_range(0.0, 50.0) = 20.0;
uniform float grey_scale : hint_range(0.0, 1.0) = 0.4;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv_scale = UV * scale;
	
	// determines what tile a pixel lands on
	float checker = mod(floor(uv_scale.x) + floor(uv_scale.y), 2.0);
	
	float final_color = clamp(checker, grey_scale, 1.0);
	
	ALBEDO = vec3(final_color);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
