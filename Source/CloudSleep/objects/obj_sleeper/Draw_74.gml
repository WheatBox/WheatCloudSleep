var str = name;
if(gShowSleeperId) {
	str = "(" + string(sleeperId) + ")" + name;
}

draw_set_color(c_black);
draw_set_alpha(gSleepersLabelAlpha);
var edgeWidth = 8 * gSleepersLabelScale;
var edgeHeight = 4 * gSleepersLabelScale;
var _strW = string_width(str) / 2 * gSleepersLabelScale;
var _strH = string_height(str) / 2 * gSleepersLabelScale;

var posX = GetPositionXOnGUI(x);
var posY = GetPositionYOnGUI(bbox_top - 34) - _strH / 2;

draw_rectangle(
	posX - _strW - edgeWidth,
	posY - _strH - edgeHeight + 4 * gSleepersLabelScale,
	posX + _strW + edgeWidth,
	posY + _strH + edgeHeight,
	false
);

draw_set_color(c_white);
// draw_set_alpha(1.0);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(posX, posY, str, gSleepersLabelScale, gSleepersLabelScale, 0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
