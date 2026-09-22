shader_type spatial;

/*
	Debug Shader
	Displays mesh as a black and white checkerboard
*/

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv_scale = UV * 10.0;
	
	// determines what tile a pixel lands on
	float checker = mod(floor(uv_scale.x) + floor(uv_scale.y), 2.0);
	
	ALBEDO = vec3(checker);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
