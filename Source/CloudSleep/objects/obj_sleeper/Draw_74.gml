var str = name;
if(gShowSleeperId) {
	str = "(" + string(sleeperId) + ")" + name;
}

var posX = GetPositionXOnGUI(x);
var posY = GetPositionYOnGUI(bbox_top - 50);

draw_set_color(c_black);
draw_set_alpha(0.7);
var edgeWidth = 8;
var edgeHeight = 4;
draw_rectangle(
	posX - string_width(str) / 2 - edgeWidth,
	posY - string_height(str) / 2 - edgeHeight + 4,
	posX + string_width(str) / 2 + edgeWidth,
	posY + string_height(str) / 2 + edgeHeight,
	false
);

draw_set_color(c_white);
draw_set_alpha(1.0);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(posX, posY, str);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

