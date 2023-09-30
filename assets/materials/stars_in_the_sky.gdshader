shader_type sky;

#include "voronoi.gdshaderinc"
#include "simple.gdshaderinc"

uniform vec3 skyColor : source_color;
uniform vec3 coldStarColor : source_color;
uniform vec3 hotStarColor : source_color;

float temperature(ivec3 pos) {
	ivec3 seed = pos * 10000; 
    return s_random(hash_4(seed.x, seed.y, seed.z, 4));
}

vec3 s_lerp(vec3 a, vec3 b, vec3 c, float t) {
    float tPos = clamp(t, 0, 1);
    float tNeg = 1.0 - clamp(t, -1, 0);

    vec3 bc = mix(b, c, tPos);
    vec3 ab = mix(b, a, tNeg);

    return t < 0.0 ? bc : ab;
}

vec3 StarColor(ivec3 pos) {
	return s_lerp(coldStarColor, vec3(1), hotStarColor, temperature(pos));
}

void sky() {
	//vec3 debug = vec3(sin(TIME));
	
	vec3 pos = EYEDIR * 0.5 + 0.5;
	
	float noise = fractal_noise(pos * 7.0, 5);
	
	ivec3 minPos;
	float dist = voronoi_3(EYEDIR * 5.0, minPos) * star_size(minPos, TIME);
	vec3 color = dist  < 0.001 ? StarColor(minPos) : skyColor * noise;
	
	COLOR = color;//dist; // * 0.5 + vec3(0.5, 0.5, 0.5);
}
