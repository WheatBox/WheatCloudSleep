/// @desc
/// @arg {real} R R
/// @arg {real} G G
/// @arg {real} B B
/// @arg {real} con 对比度
/// @arg {real} sat 饱和度
/// @arg {real} brt 亮度
function add_key_time(R, G, B, con, sat, brt, pop_strength, pop_threshold) {
	if(is_undefined(color[0][0])) {
		var i = 0;
	} else {
		var i = array_length(color); // 返回数组的第一维的长度
		// var i = array_length(color[0]); // 返回数组的第二维的长度
	}
	
	color[i][0] = R / 255;
	color[i][1] = G / 255;
	color[i][2] = B / 255;
	
	con_sat_brt[i][0] = con;
	con_sat_brt[i][1] = sat;
	con_sat_brt[i][2] = brt;
	
	con_sat_brt[i][3] = pop_strength;
	con_sat_brt[i][4] = pop_threshold;
}