shader_type canvas_item;

void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
}
