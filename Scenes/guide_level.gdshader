shader_type canvas_item;

uniform vec4 color_main : source_color = vec4(1.0, 0.45, 0.75, 1.0);
uniform vec4 color_light : source_color = vec4(1.0, 0.65, 0.85, 1.0);
uniform vec4 color_dark : source_color = vec4(0.95, 0.30, 0.65, 1.0);

uniform float speed = 0.6;
uniform float wave_strength = 0.03;
uniform float line_density = 28.0;

void fragment() {
	vec2 uv = UV;
	float t = TIME * speed;

	float wave1 = sin(uv.y * 8.0 + t * 1.2) * wave_strength;
	float wave2 = cos(uv.y * 14.0 - t * 0.8) * (wave_strength * 0.6);

	uv.x += wave1 + wave2;

	float lines = sin((uv.y + wave1) * line_density + t * 0.8);
	lines = lines * 0.5 + 0.5;

	float soft_flow = sin(uv.y * 5.0 + t * 0.5) * 0.5 + 0.5;

	vec4 col = mix(color_main, color_light, soft_flow);
	col = mix(col, color_dark, lines * 0.18);

	COLOR = col;
}