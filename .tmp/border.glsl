precision mediump float;

varying vec2 v_coords;
uniform vec2 size;
uniform vec2 u_camera;

// --- ВЫБЕРИ ЦВЕТ (R, G, B, Alpha) ---
// Приятный глубокий графит (не выжигает глаза):
const vec4 BG_COLOR = vec4(0.15, 0.15, 0.15, 1.0); // #17171a
// ------------------------------------

void main() {
    gl_FragColor = BG_COLOR;
}
