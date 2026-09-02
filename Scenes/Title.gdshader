shader_type canvas_item;

// Convert RGB to HSL helper
vec3 rgb_to_hsl(vec3 c) {
    float cmin = min(min(c.r, c.g), c.b);
    float cmax = max(max(c.r, c.g), c.b);
    float delta = cmax - cmin;
    float h = 0.0;
    float s = 0.0;
    float l = (cmax + cmin) / 2.0;

    if (delta > 0.00001) {
        s = l < 0.5 ? delta / (cmax + cmin) : delta / (2.0 - cmax - cmin);
        if (cmax == c.r) h = (c.g - c.b) / delta + (c.g < c.b ? 6.0 : 0.0);
        else if (cmax == c.g) h = (c.b - c.r) / delta + 2.0;
        else h = (c.r - c.g) / delta + 4.0;
        h /= 6.0;
    }
    return vec3(h, s, l);
}

// Helper for HSL to RGB conversion
float hue_to_rgb(float p, float q, float t) {
    if (t < 0.0) t += 1.0;
    if (t > 1.0) t -= 1.0;
    if (t < 1.0/6.0) return p + (q - p) * 6.0 * t;
    if (t < 0.5) return q;
    if (t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
    return p;
}

vec3 hsl_to_rgb(vec3 c) {
    if (c.y == 0.0) return vec3(c.z);
    float q = c.z < 0.5 ? c.z * (1.0 + c.y) : c.z + c.y - c.z * c.y;
    float p = 2.0 * c.z - q;
    return vec3(
        hue_to_rgb(p, q, c.x + 1.0/3.0),
        hue_to_rgb(p, q, c.x),
        hue_to_rgb(p, q, c.x - 1.0/3.0)
    );
}

void fragment() {
    vec4 base = texture(TEXTURE, UV); // Bottom layer
    vec4 blend = COLOR; // Or sample a top texture/screen texture
    
    vec3 base_hsl = rgb_to_hsl(base.rgb);
    vec3 blend_hsl = rgb_to_hsl(blend.rgb);
    
    // Color blend mode: Take Hue and Saturation from blend, Luminosity from base
    vec3 final_hsl = vec3(blend_hsl.r, blend_hsl.g, base_hsl.b);
    vec3 final_rgb = hsl_to_rgb(final_hsl);
    
    COLOR = vec4(final_rgb, base.a);
}
