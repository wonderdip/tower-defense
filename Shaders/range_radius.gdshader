shader_type canvas_item;

uniform float border_px = 4.0;
uniform vec4 circle_color : source_color = vec4(1.0);
uniform vec4 border_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	// UV is guaranteed square because your rect is square
	vec2 p = UV * 2.0 - 1.0; // -1..1
	float dist = length(p);

	// Convert border from pixels to UV
	float border = (border_px * 4.0) / (1.0 / SCREEN_PIXEL_SIZE.x);

	float outer = step(dist, 1.0);
	float inner = step(dist, 1.0 - border);

	float border_mask = outer - inner;

	vec4 col = vec4(0.0);
	col += circle_color * inner;
	col += border_color * border_mask;

	COLOR = col;
	COLOR.a = max(inner * circle_color.a, border_mask * border_color.a);
}
