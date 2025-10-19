shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 1.0;

void fragment() {
    vec2 texture_size = vec2(textureSize(TEXTURE, 0));
    vec2 pixel_size = 1.0 / texture_size;
    
    vec4 color = texture(TEXTURE, UV);
    
    // If current pixel is transparent, check surrounding pixels for outline
    if (color.a < 0.1) {
        float outline = 0.0;
        
        // Sample surrounding pixels in a cross pattern
        for (float x = -outline_width; x <= outline_width; x += 1.0) {
            for (float y = -outline_width; y <= outline_width; y += 1.0) {
                vec2 offset = vec2(x, y) * pixel_size;
                vec4 sample_color = texture(TEXTURE, UV + offset);
                
                // If we find a non-transparent pixel nearby, we're on the outline
                if (sample_color.a > 0.1) {
                    outline = 1.0;
                    break;
                }
            }
            if (outline > 0.0) break;
        }
        
        if (outline > 0.0) {
            COLOR = outline_color;
        } else {
            COLOR = vec4(0.0, 0.0, 0.0, 0.0); // Transparent
        }
    } else {
        // Keep original pixel
        COLOR = color;
    }
}