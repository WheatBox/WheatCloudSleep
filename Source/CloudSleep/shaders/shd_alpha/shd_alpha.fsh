//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float alpha;

void main()
{
    gl_FragColor = texture2D( gm_BaseTexture, v_vTexcoord ) * vec4(1.0, 1.0, 1.0, alpha);
}
