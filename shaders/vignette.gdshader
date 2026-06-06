shader_type canvas_item;

uniform float alpha = 1.0;
uniform vec2 half_size = vec2(0.4, 0.4); // половина размера прямоугольника в UV
uniform float corner_radius = 0.15;      // радиус скругления
uniform float feather = 0.02;            // мягкость края

void fragment() {
	vec2 p = abs(UV - vec2(0.5)) - (half_size - vec2(corner_radius));
	vec2 q = max(p, vec2(0.0));
	float dist = length(q) + min(max(p.x, p.y), 0.0) - corner_radius;

	float a = smoothstep(0.0, feather, dist);
	COLOR = vec4(0.0, 0.0, 0.0, a * alpha);
}