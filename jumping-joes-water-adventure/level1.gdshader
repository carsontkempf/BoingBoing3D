shader_type canvas_item;

uniform float occlusion_strength : hint_range(0.0, 1.0) = 0.5; // Adjust occlusion darkness
uniform float occlusion_thickness : hint_range(0.0, 1.0) = 0.2; // Adjust border thickness
uniform vec4 occlusion_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Occlusion color

void fragment() {
    vec2 uv = UV;
    vec2 pixel_coord = FRAGMENT_COORD;
    vec2 tile_size = TEXTURE_PIXEL_SIZE * TILE_SET_ATLAS_SIZE;
    vec2 tile_uv = floor(pixel_coord / tile_size);

    vec4 original_color = texture(TEXTURE, uv);
    vec4 occlusion = vec4(0.0);

    // Check neighbors for occlusion (simplified - can be expanded)
    if (texelFetch(TEXTURE, ivec2(pixel_coord - ivec2(0, 1)), 0).a == 0.0) { // Top neighbor
        occlusion += vec4(1.0);
    }
    if (texelFetch(TEXTURE, ivec2(pixel_coord - ivec2(1, 0)), 0).a == 0.0) { // Left neighbor
        occlusion += vec4(1.0);
    }
    if (texelFetch(TEXTURE, ivec2(pixel_coord + ivec2(0, 1)), 0).a == 0.0) { // Bottom neighbor
        occlusion += vec4(1.0);
    }
    if (texelFetch(TEXTURE, ivec2(pixel_coord + ivec2(1, 0)), 0).a == 0.0) { // Right neighbor
        occlusion += vec4(1.0);
    }

    float occlusion_factor = clamp(dot(occlusion, vec4(1.0)) * occlusion_thickness, 0.0, 1.0) * occlusion_strength;
    vec4 final_color = mix(original_color, occlusion_color, occlusion_factor);

    COLOR = final_color;
}