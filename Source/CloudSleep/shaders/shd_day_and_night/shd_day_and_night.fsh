//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 col;
uniform float con_sat_brt[5];

#define contrast con_sat_brt[0]
#define saturation con_sat_brt[1]
#define brightness con_sat_brt[2]

#define pop_strength con_sat_brt[3]
#define pop_threshold con_sat_brt[4]

void main()
{
	vec3 out_col = texture2D( gm_BaseTexture, v_vTexcoord ).rgb;
	
	float grey = dot(out_col, vec3(0.299, 0.587, 0.114));
	
	out_col = (out_col - 0.5) * contrast + 0.5;
	out_col = out_col + pop_strength * max(grey - pop_threshold, 0.0);
	out_col = mix(vec3(grey), out_col, saturation);
	out_col = out_col + brightness;
	
    gl_FragColor = vec4(out_col * col, 1.0);
}
