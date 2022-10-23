if(gAutoDayNight)
	daytime = (current_hour + current_minute / 60);

var time = daytime / 24;

key_previous = min(floor(time * keytimesCount), keytimesCount - 1);
key_next = (key_previous + 1) mod keytimesCount;

var lerp_amt = (time - key_previous / keytimesCount) * keytimesCount;

color_mix = [
	lerp(color[key_previous][0], color[key_next][0], lerp_amt),
	lerp(color[key_previous][1], color[key_next][1], lerp_amt),
	lerp(color[key_previous][2], color[key_next][2], lerp_amt),
];

con_sat_brt_mix = [
	lerp(con_sat_brt[key_previous][0], con_sat_brt[key_next][0], lerp_amt),
	lerp(con_sat_brt[key_previous][1], con_sat_brt[key_next][1], lerp_amt),
	lerp(con_sat_brt[key_previous][2], con_sat_brt[key_next][2], lerp_amt),
	
	lerp(con_sat_brt[key_previous][3], con_sat_brt[key_next][3], lerp_amt),
	lerp(con_sat_brt[key_previous][4], con_sat_brt[key_next][4], lerp_amt),
];

alpha = clamp(sin((2 * daytime + 0.5) * 3.14) * 1.0 - 0.1, 0, 1);


