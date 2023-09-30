shader_type spatial;

varying vec3 instance_pos;

void vertex() {
	instance_pos = VERTEX;
}

#include "simple.gdshaderinc"

uniform float aplha;
uniform float scale;
uniform float speed;
uniform vec3 color : source_color;

void fragment() {
	vec3 wrld_vertex = instance_pos;

	float noise = fractal_noise((wrld_vertex - vec3(speed * TIME)) * scale, 3);
	ALBEDO = mix(color, vec3(1.0), noise);
	ALPHA = aplha;
}
