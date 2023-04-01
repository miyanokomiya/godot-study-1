shader_type canvas_item;

uniform vec2 scroll1 = vec2(0.1, 0.1);
uniform vec2 scroll2 = vec2(0.1, 0.1);
uniform sampler2D color_texture;
uniform float power = 1;

void fragment() {
	float texture_color1 = texture(TEXTURE, UV + scroll1 * TIME).r;
	float texture_color2 = texture(TEXTURE, UV + scroll2 * TIME).r;
	float reduction = (1.0 - UV.y) * 0.6 - (1.0 - exp(abs(UV.x - 0.5)) * 0.9) * 0.5;
	float energy = texture_color1 * texture_color2 - reduction * (2.0 - power);
	vec4 color = texture(color_texture, vec2(energy));
	COLOR = color;
}
