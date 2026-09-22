shader_type spatial;

/*
	Debug Shader
	Displays mesh as a black and white checkerboard
*/

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(fract(UV.x), fract(UV.y), 0.0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
