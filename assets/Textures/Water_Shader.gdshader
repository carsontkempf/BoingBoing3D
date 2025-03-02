shader_type particles;

// Uniforms to control randomness & physics
uniform float turbulence = 1.0;   // Controls random motion
uniform float gravity_strength = 9.8;  // Simulates downward force
uniform float fade_speed = 1.0;   // Controls fading effect

// Function to generate a random float based on UV coordinates
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void start() {
    // Use CUSTOM.xy (user-defined values) as the random seed
    vec2 seed = vec2(TIME, CUSTOM.x);
    float random_x = rand(seed);
    float random_y = rand(seed * 2.0);

    // Initial velocity: Moves downward like water with randomness
    VELOCITY = vec3(random_x * turbulence - turbulence / 2.0, -random_y * 5.0, 0.0);

    // Initial color: Light blue tint
    COLOR = vec4(0.2, 0.4, 1.0, 1.0);
}

void process() {
    // Apply gravity to the particle
    VELOCITY.y += gravity_strength * DELTA;

    // Fade out effect over time
    COLOR.a -= DELTA * fade_speed;
}