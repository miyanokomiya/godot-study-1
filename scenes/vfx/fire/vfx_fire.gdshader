shader_type canvas_item;

uniform sampler2D noise: repeat_enable;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec4 n = texture(noise, vec2(UV.x, UV.y + TIME));
	
	base.r += 0.4 - distance(vec2(0.5, UV.y), UV);
	base.r = (base.r * 0.3) + (n.r * 0.4);
	COLOR = vec4(float(base.r > 0.4), float(base.r > 0.5), float(base.r > 0.6), float(base.r > 0.4));
}
