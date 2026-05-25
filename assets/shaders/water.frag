#include <flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform float time;
uniform vec2 touch;
uniform float ripple;

out vec4 fragColor;

void main() {
    vec2 uv = gl_FragCoord.xy / resolution;

    // distance from touch
    float dist = distance(uv, touch);

    // ripple wave
    float wave = sin(dist * 40.0 - time * 4.0) * 0.01;

    // fade ripple outward
    float effect = smoothstep(ripple, 0.0, dist);

    uv += wave * effect;

    fragColor = vec4(uv, 0.5, 1.0);
}