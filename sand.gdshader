shader_type canvas_item;

// First wave color, adjustable via color picker in the editor
uniform vec4 water_color_1 : source_color = vec4(0.2, 0.6, 0.8, 0.5);
// Second wave color, adjustable via color picker in the editor
uniform vec4 water_color_2 : source_color = vec4(0.1, 0.5, 0.7, 0.4);
// Water level percentage, range 0.0 to 1.0, adjustable via slider in the editor
uniform float water_level_percentage : hint_range(0.0, 1.0) = 0;
// First wave frequency, controls wave density, range adjustable as needed, via slider in the editor
uniform float wave_frequency_1 : hint_range(1.0, 50.0) = 10.0;
// First wave amplitude, controls wave height, range adjustable as needed, via slider in the editor
uniform float wave_amplitude_1 : hint_range(0.0, 0.5) = 0.05;
// Second wave frequency, range adjustable as needed, via slider in the editor
uniform float wave_frequency_2 : hint_range(1.0, 50.0) = 15.0;
// Second wave amplitude, range adjustable as needed, via slider in the editor
uniform float wave_amplitude_2 : hint_range(0.0, 0.5) = 0.03;
uniform float pixelation_level : hint_range(1.0, 100.0) = 90.0;
uniform float color_variation_strength : hint_range(0.0, 1.0) = 0.05;
// How much pixel color variation to apply
// Speed of color variation movement (grain flow)
uniform float color_flow_speed : hint_range(0.0, 10.0) = 0.1;
// Simple noise function to generate random valu
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

// Smooth noise function to create more natural noise
float smooth_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(
        mix(rand(i), rand(i + vec2(1.0, 0.0)), u.x),
        mix(rand(i + vec2(0.0, 1.0)), rand(i + vec2(1.0, 1.0)), u.x),
        u.y
    );
}

// Encapsulates wave calculation logic
float calculate_wave_offset(float frequency, float amplitude, float time_multiplier, vec2 uv) {
    // Regular sine wave
    float wave = sin(uv.x * frequency + TIME * time_multiplier) * amplitude;

    // Pixelation: quantize wave to pixel steps
    float step_size = 1.0 / pixelation_level;
    wave = floor(wave / step_size) * step_size;
wave += rand(floor(uv * pixelation_level)) * step_size * 0.3; // subtle jitter
    return wave;
}

// Encapsulates color blending logic
vec4 blend_water_color(vec4 base_color, vec4 water_color, float mask) {
    return mix(base_color, water_color, water_color.a * mask);
}

void fragment() {
    vec2 uv = UV;
    vec4 tex_color = texture(TEXTURE, uv);
    float mask = tex_color.a;

    // Step 1: Fully transparent if outside alpha mask
    if (mask <= 0.0) {
        COLOR = vec4(0.0);
    }

    // Step 2: Calculate both wave offsets
    float wave_offset_1 = calculate_wave_offset(wave_frequency_1, wave_amplitude_1, 2.0, uv);
    float wave_offset_2 = calculate_wave_offset(wave_frequency_2, wave_amplitude_2, 3.0, uv);

    float water_level_1 = 1.0 - water_level_percentage + wave_offset_1;
    float water_level_2 = 1.0 - water_level_percentage + wave_offset_2;

    // Step 3: Only show pixels below at least one wave level
    bool below_wave_1 = uv.y >= water_level_1;
    bool below_wave_2 = uv.y >= water_level_2;

    if (!below_wave_1 && !below_wave_2) {
        // Above both waves = invisible
        COLOR = vec4(0.0);
    }

    // Optional: add some subtle noise to simulate flow
    vec2 noise_uv = uv * 10.0 + vec2(TIME * 0.5, 0.0);
    float noise = smooth_noise(noise_uv);
    float noise_offset = noise * 0.05;
    vec2 noisy_uv = uv + vec2(noise_offset);

    // Start with transparent color
    vec4 final_color = vec4(0.0);

    // Step 4: Use wave colors directly (not blending with texture)
    if (below_wave_1) {
        final_color = mix(final_color, water_color_1, water_color_1.a);
    }
    if (below_wave_2) {
        final_color = mix(final_color, water_color_2, water_color_2.a);
    }
vec2 flow_uv = UV;
flow_uv.x += TIME * color_flow_speed;
float wave_motion = (calculate_wave_offset(wave_frequency_1, wave_amplitude_1, 2.0, UV) +
                     calculate_wave_offset(wave_frequency_2, wave_amplitude_2, 3.0, UV)) * 0.5;
flow_uv.y += wave_motion * 2.0;
vec2 pixel_uv = floor(flow_uv * pixelation_level);
float variation = rand(pixel_uv) * color_variation_strength;
final_color.rgb += variation;
    // Step 5: Apply mask alpha
    final_color.a *= mask;

    COLOR = final_color;
}
