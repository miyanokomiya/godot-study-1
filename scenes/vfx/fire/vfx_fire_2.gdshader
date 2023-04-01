shader_type canvas_item;

uniform sampler2D noise: repeat_enable;
uniform float radius = 0.45;
uniform float blur = 0.01;
uniform float ellipticity = 1.2;

uniform bool makePixelate = false;
uniform int pixelateSize = 32;

void fragment(){
	vec2 uv = UV - .5;
	uv.y *= -1.;
	
	if(makePixelate){
	    uv = round(uv * float(pixelateSize)) / float(pixelateSize);
	}
	
	float color = smoothstep(radius, radius - blur, length(vec2(uv.x * ellipticity, uv.y + abs(uv.y) * step(0.5, radius))));
	color *= 1. - smoothstep(-0.4, 0.6, uv.y);
	color += 0.4 - abs(uv.x);
	
	uv.y -= TIME;
	float n = texture(noise, uv).r;
	
	float red = step(.4, color * .3 + n * .4);
	float green = step(.5, color * .3 + n * .4);
	float blue = step(.6, color * .3 + n * .4);
	
	COLOR = vec4(vec3(red, green, blue), red);
}