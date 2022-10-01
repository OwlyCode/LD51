shader_type canvas_item;

void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	COLOR.rgb = vec3(dot(COLOR.rgb, vec3(0.299, 0.587, 0.114)));
}