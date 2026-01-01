shader_type canvas_item;

// Top-down pixelated foam & caustic shader for TileMap (Godot 4.5)
// - Use as a ShaderMaterial on a TileMap or on individual tiles.
// - Pixelates the tile texture (optional) and projects a world-aligned
//   pixelated caustics/foam pattern that lines up across tiles.
// - Provide a small tiled caustics texture (grayscale). Optionally a noise and normal map.

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

// Textures
uniform sampler2D caustics_tex : hint_default_white;   // grayscale caustic tile (looping)
uniform sampler2D noise_tex : hint_default_white;      // optional noise (looping)
uniform sampler2D normal_map : hint_normal;    // optional per-tile normal map (tile-space)

// Base texture pixelation
uniform bool pixelate_texture = true;
uniform float texture_pixel_size : hint_range(1, 64, 1) = 2.0; // tile texture pixel block size (in texels)

// Caustics controls (world/screen aligned so it lines up across tiles)
uniform float caustic_pixel_size : hint_range(1, 128, 1) = 8.0; // size of caustic "pixels" in screen pixels
uniform float caustic_scale : hint_range(0.1, 8.0, 0.1) = 1.0;   // tiling multiplier for caustics texture
uniform vec2 caustic_move = vec2(0.25, 0.12); // direction vector (small values)
uniform float caustic_speed : hint_range(0.0, 8.0, 0.01) = 0.8; // global speed multiplier
uniform float caustic_strength : hint_range(0.0, 4.0, 0.01) = 0.6; // caustic intensity multiplier
uniform vec3 caustic_tint = vec3(0.6, 0.9, 1.0); // tint for caustics

// Foam controls
uniform float foam_threshold : hint_range(0.0, 1.0, 0.01) = 0.65; // threshold for foam formation
uniform float foam_softness : hint_range(0.0, 0.5, 0.01) = 0.05;   // smoothing around threshold
uniform float foam_strength : hint_range(0.0, 2.0, 0.01) = 1.0;    // blend strength of foam
uniform vec3 foam_color: source_color =  vec3(1.0);                  // foam color

// Variation & normal influence
uniform bool use_noise_for_variation = true;
uniform float noise_scale : hint_range(0.1, 8.0, 0.01) = 2.0;
uniform float noise_strength : hint_range(0.0, 1.0, 0.01) = 0.25;

uniform bool use_normal_influence = false;
uniform float normal_influence : hint_range(0.0, 4.0, 0.01) = 1.0; // add foam where normal indicates slope

void fragment() {
	// 1) Base tile sampling (optional pixelation)
	vec2 base_uv = UV;
	vec4 base_col;
	if (pixelate_texture) {
		// textureSize returns ivec2; cast to vec2
		ivec2 ts = textureSize(TEXTURE, 0);

		vec2 texSize = vec2(max(float(ts.x), 1.0), max(float(ts.y), 1.0));
		vec2 q = floor(base_uv * texSize / texture_pixel_size) * texture_pixel_size / texSize;
		base_col = texture(TEXTURE, q);
	} else {
		base_col = texture(TEXTURE, base_uv);
	}

	// 2) Build world/screen aligned caustic UV so pattern lines up across tiles
	ivec2 ss = textureSize(SCREEN_TEXTURE, 0);
	vec2 screenSize = vec2(max(float(ss.x), 1), max(float(ss.y), 1));
	vec2 world_px = SCREEN_UV * screenSize;

	// animate caustics: direction * TIME * speed (scaled to make small vectors useful)
	world_px += caustic_move * (TIME * caustic_speed * 100.0);

	// quantize to get pixelated caustics aligned in screen-space
	vec2 world_px_quant = floor(world_px / caustic_pixel_size) * caustic_pixel_size;
	vec2 caustics_uv = (world_px_quant / screenSize) * caustic_scale;
	vec2 caustics_uv_wrapped = fract(caustics_uv);

	// sample caustics texture (assume grayscale stored in .r)
	float caustic_raw = texture(caustics_tex, caustics_uv_wrapped).r;

	// optional noise (sample in world-space so it lines up across tiles)
	float noise_val = 0.0;
	ivec2 nts = textureSize(noise_tex, 0);
	if (use_noise_for_variation && nts.x > 0 && nts.y > 0) {
		vec2 noise_uv = fract((world_px / screenSize) * noise_scale);
		noise_val = texture(noise_tex, noise_uv).r * noise_strength;
	}

	float caustic_val = clamp(caustic_raw + noise_val, 0.0, 1.0);
	vec3 caustic_col = caustic_tint * (caustic_val * caustic_strength);

	// 3) Foam mask from caustic brightness (soft threshold)
	float foam_mask = smoothstep(foam_threshold - foam_softness, foam_threshold + foam_softness, caustic_val);

	// optionally boost foam at tile edges using a per-tile normal map
	ivec2 nms = textureSize(normal_map, 0);
	if (use_normal_influence && nms.x > 0 && nms.y > 0) {
		vec3 n = texture(normal_map, base_uv).rgb;
		vec3 normal = normalize(n * 2.0 - 1.0);
		float slope_factor = clamp((1.0 - normal.z) * normal_influence, 0.0, 1.0);
		foam_mask = clamp(foam_mask + slope_factor, 0.0, 1.0);
	}

	// foam color blended over base
	vec3 foam_col_final = mix(base_col.rgb, foam_color, foam_mask * foam_strength);

	// 4) Apply caustic lighting (subtle multiply + additive tint)
	vec3 lit = base_col.rgb * (1.0 + caustic_col * 0.5) + caustic_col * 0.6;

	// combine foam over lit result (foam overrides highlights where present)
	vec3 out_rgb = mix(lit, foam_col_final, foam_mask * foam_strength);

	COLOR = vec4(out_rgb, base_col.a);
}