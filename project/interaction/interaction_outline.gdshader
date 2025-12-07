shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0;
uniform int pattern : hint_range(0, 2) = 0; // diamond, circle, square
uniform bool inside = false;
uniform bool add_margins = true; // only useful when inside is false

void vertex() {
	if (add_margins) {
		VERTEX += (UV * 2.0 - 1.0) * width;
	}
}

bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D texture) {
	int maxw = int(ceil(width));
	for (int i = -maxw; i <= maxw; i++) {
		float xf = float(i);
		float x = abs(xf) > width ? width * sign(xf) : xf;
		float offset;
		
		if (pattern == 0) {
			offset = width - abs(x);
		} else if (pattern == 1) {
			offset = floor(sqrt(pow(width + 0.5, 2.0) - x * x));
		} else {
			offset = width;
		}
		
		int maxi = int(ceil(offset));
		for (int j = -maxi; j <= maxi; j++) {
			float yf = float(j);
			float y = abs(yf) > offset ? offset * sign(yf) : yf;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			// outside texture or transparent pixel
			if ((xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(texture, xy).a <= 0.0) == inside) {
				return true;
			}
		}
	}
	
	return false;
}

void fragment() {
	vec2 uv = UV;
	vec4 out_col = vec4(0.0);
	vec4 node_modulate = COLOR; // the CanvasItem's modulate color + alpha
	float node_alpha = node_modulate.a;
	
	if (add_margins) {
		// Compute effective pixel size when we've expanded vertices by width in vertex()
		vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(width * 2.0));
		uv = (uv - texture_pixel_size * width) * TEXTURE_PIXEL_SIZE / texture_pixel_size;
		if (uv != clamp(uv, vec2(0.0), vec2(1.0))) {
			out_col = vec4(0.0);
		} else {
			out_col = texture(TEXTURE, uv);
		}
	} else {
		out_col = texture(TEXTURE, uv);
	}
	
	if ((out_col.a > 0.0) == inside && hasContraryNeighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
		vec3 base_rgb = out_col.rgb;
		float base_a = out_col.a;
		
		if (inside) {
			base_rgb = mix(base_rgb, color.rgb, color.a);
		} else {
			base_rgb = color.rgb;
		}
		
		float new_a = base_a + (1.0 - base_a) * color.a;
		out_col.rgb = base_rgb;
		out_col.a = new_a;
	}
	
	// Apply node modulate alpha so the whole result can be faded by the node.
	out_col.a *= node_alpha;
	
	COLOR = out_col;
}