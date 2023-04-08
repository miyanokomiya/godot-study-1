shader_type canvas_item;

uniform vec4 base_color: source_color = vec4(255, 0, 0, 1);
uniform float alpha: hint_range(0.0, 1.0) = 1;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR.rgb = base_color.rgb;
	if (distance(UV, vec2(0.5, 0.5)) < 0.36) {
		COLOR.a = texture_color.a * texture_color.a * base_color.a * alpha;
	} else {
		COLOR.a = 0.0;
	}
}
