shader_type canvas_item;
render_mode unshaded;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	if (c != vec4(1.0, 1.0, 1.0, 1.0)) {
		c.r = 1.0;
		c.g = 1.0;
		c.b = 1.0;
		c.a = 1.0;
	}
	else if (c == vec4(1.0, 1.0, 1.0, 1.0)) {
		c.r = 0.6784313725490196;
		c.g = 0.0;
		c.b = 0.0;
		c.a = 1.0;
	}
	COLOR = c;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
