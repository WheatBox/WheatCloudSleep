daytime = 0;

application_surface_draw_enable(false);

shader = shd_day_and_night;

u_col = shader_get_uniform(shader,"col");
u_con_sat_brt = shader_get_uniform(shader, "con_sat_brt");

s_lights = shader_get_sampler_index(shader, "lights");
tex_lights = -1;
surf_lights = -1;

color_mix = -1;
color[0][0] = undefined;

con_sat_brt_mix = -1;
con_sat_brt[0][0] = undefined;

key_previous = -1;
key_next = -1;

add_key_time(20, 27, 58, 0.8, 0.8, 0.0, 2.5, 0.7); // 午夜
add_key_time(20, 27, 58, 0.8, 0.8, 0.0, 2.5, 0.7); // 午夜
add_key_time(20, 27, 58, 0.8, 0.8, 0.0, 2.5, 0.7); // 午夜

add_key_time(20, 27, 58, 0.9, 0.9, 0.0, 2.0, 0.75); // 后半夜
add_key_time(20, 27, 58, 0.9, 0.9, 0.0, 1.5, 0.6); // 后半夜

add_key_time(180, 170, 190, 0.9, 0.9, 0.04, 1.0, 0.4); // 凌晨

add_key_time(254, 255, 250, 1.0, 0.9, 0.07, 0, 0); // 清晨
add_key_time(254, 255, 250, 1.0, 0.9, 0.07, 0, 0); // 清晨

add_key_time(240, 240, 240, 1.0, 1.0, 0.07, 0, 0); // 上午
add_key_time(240, 240, 240, 1.0, 1.0, 0.07, 0, 0); // 上午
add_key_time(240, 240, 240, 1.0, 1.0, 0.07, 0, 0); // 上午
add_key_time(240, 240, 240, 1.0, 1.0, 0.07, 0, 0); // 上午

add_key_time(230, 230, 230, 1.0, 1.0, 0.07, 0, 0); // 中午
add_key_time(230, 230, 230, 1.0, 1.0, 0.07, 0, 0); // 中午
add_key_time(230, 230, 230, 1.0, 1.0, 0.07, 0, 0); // 中午
add_key_time(230, 230, 230, 1.0, 1.0, 0.07, 0, 0); // 中午

add_key_time(180, 180, 180, 1.0, 1.0, 0.07, 0, 0); // 下午

add_key_time(165, 140, 140, 1.1, 1.0, 0.07, 0, 0); // 傍晚

add_key_time(80, 80, 84, 1.0, 0.9, 0.07, 1.0, 0.3); // 夜晚
add_key_time(80, 80, 84, 1.0, 0.9, 0.07, 1.0, 0.3); // 夜晚
add_key_time(20, 27, 58, 1.0, 0.9, 0.07, 2.0, 0.75); // 夜晚
add_key_time(20, 27, 58, 1.0, 0.9, 0.07, 2.0, 0.75); // 夜晚
add_key_time(20, 27, 58, 1.0, 0.9, 0.04, 2.0, 0.75); // 夜晚
add_key_time(20, 27, 58, 1.0, 0.9, 0.01, 2.0, 0.75); // 夜晚

keytimesCount = array_length(color);
/*
var layer_night_reflection = layer_get_id("night_reflection");
layer_script_begin(layer_night_reflection, set_alpha);
layer_script_end(layer_night_reflection, reset_alpha);
*/
u_alpha = shader_get_uniform(shd_alpha, "alpha");
alpha = 0;


