shader_type canvas_item;

float rand(vec2 co, float step) {
    return fract(cos(dot(co * step, vec2(15.2851, 18.435))) * 74687.84583);
}

void fragment() {
	
	float lines_count = 18.;
	float cols_count = 2.;
	float resolution_y = 920.;
	float resolution_x = 1024.;
	float line_height = resolution_y/lines_count;
	float col_height = resolution_x/cols_count;
	vec2 coords = SCREEN_UV;
	float line = resolution_y*coords.y/line_height-20.*cos(TIME/20.);;
	float col = resolution_x*coords.x/col_height-TIME/10.;
	float line_index = cos((fract(line+1.))/2.);
	float col_index = log(cos((fract(col)+1.)/2.));
	
	vec4 color = min(texture(TEXTURE, UV), COLOR);
	COLOR = vec4(
		color.xyz * (line_index+col_index+0.2)/2.+
		vec3(rand(UV, 2.), 0, rand(UV, 3.))*0.1, 
		color.a);
}
