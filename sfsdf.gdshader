shader_type canvas_item;

void fragment() 
{
	vec2 remap_uv = abs((UV - 0.5) * 2.0);
	vec2 highlight_smoothstep = smoothstep(vec2(0.0), vec2(0.25), 1.0 - remap_uv);
	float mask = (highlight_smoothstep.x * highlight_smoothstep.y);
	
    vec4 main_texture = texture(TEXTURE, UV);
	COLOR.a = mix(0.,1., main_texture.a*mask);
}