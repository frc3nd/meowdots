#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;
varying vec2 v_texcoord;

void main() {
    vec4 color = texture2D(tex, v_texcoord);

    // Переводим в полумонохром (30% цвета)
    float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 grayScale = mix(vec3(lum), color.rgb, 0.3);

    // Снижаем общую яркость на 25% (темно-серый тон)
    grayScale *= 0.75;

    // Расчет виньетки от центра (0.5, 0.5)
    vec2 uv = v_texcoord - vec2(0.5);
    float dist = length(uv);
    // Плавное затемнение к углам
    float vignette = smoothstep(0.75, 0.2, dist);

    gl_FragColor = vec4(grayScale * vignette, color.a);
}
