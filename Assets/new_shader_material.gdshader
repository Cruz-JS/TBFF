shader_type canvas_item;

// 1. ADDED: This exposes a color picker in the Godot Inspector
uniform vec4 target_blend_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); 

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

vec3 rgb_to_hsl(vec3 c) {
    float cmin = min(c.r, min(c.g, c.b));
    float cmax = max(c.r, max(c.g, c.b));
    float delta = cmax - cmin;
    
    float h = 0.0;
    float s = 0.0;
    float l = (cmax + cmin) / 2.0;
    
    if (delta > 0.0) {
        s = l < 0.5 ? delta / (cmax + cmin) : delta / (2.0 - cmax - cmin);
        
        if (c.r == cmax) {
            h = (c.g - c.b) / delta + (c.g < c.b ? 6.0 : 0.0);
        } else if (c.g == cmax) {
            h = (c.b - c.r) / delta + 2.0;
        } else {
            h = (c.r - c.g) / delta + 4.0;
        }
        h /= 6.0;
    }
    return vec3(h, s, l);
}

float hue_to_rgb(float p, float q, float t) {
    if (t < 0.0) t += 1.0;
    if (t > 1.0) t -= 1.0;
    if (t < 1.0/6.0) return p + (q - p) * 6.0 * t;
    if (t < 1.0/2.0) return q;
    if (t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
    return p;
}

vec3 hsl_to_rgb(vec3 hsl) {
    float r, g, b;
    if (hsl.y == 0.0) {
        r = g = b = hsl.z;
    } else {
        float q = hsl.z < 0.5 ? hsl.z * (1.0 + hsl.y) : hsl.z + hsl.y - hsl.z * hsl.y;
        float p = 2.0 * hsl.z - q;
        r = hue_to_rgb(p, q, hsl.x + 1.0/3.0);
        g = hue_to_rgb(p, q, hsl.x);
        b = hue_to_rgb(p, q, hsl.x - 1.0/3.0);
    }
    return vec3(r, g, b);
}

void fragment() {
    vec4 base_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    
    // 2. CHANGED: Replaced texture(TEXTURE, UV) with your custom uniform color
    vec4 blend_color = target_blend_color; 
    
    vec3 base_hsl = rgb_to_hsl(base_color.rgb);
    vec3 blend_hsl = rgb_to_hsl(blend_color.rgb);
    
    vec3 final_hsl = vec3(blend_hsl.x, blend_hsl.y, base_hsl.z);
    vec3 final_rgb = hsl_to_rgb(final_hsl);
    
    // Uses the alpha channel from your inspector color to control blend strength
    COLOR = vec4(final_rgb, blend_color.a * base_color.a);
}
