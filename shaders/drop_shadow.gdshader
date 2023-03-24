shader_type canvas_item;

uniform vec4 shadow_color : source_color;
// Currently pixels always in application size, so zooming in further wouldn't increase the size of the dropdown
// but changing that would also be relatively trivial
uniform vec2 offset_in_pixels;

void fragment() {
	
	COLOR *= texture(TEXTURE, UV);
	vec4 color = texture(TEXTURE, UV - offset_in_pixels*TEXTURE_PIXEL_SIZE);
	
	if (COLOR.a == 0. && color.a > 0.) {
		COLOR = shadow_color;
	}
}