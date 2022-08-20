draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(
	GetPositionXOnGUI(x - string_width(name)),
	GetPositionYOnGUI(y - string_height(name)),
	GetPositionXOnGUI(x + string_width(name)),
	GetPositionYOnGUI(y + string_height(name)),
	false
);

draw_set_color(c_white);
draw_set_alpha(1.0);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(GetPositionXOnGUI(x), GetPositionYOnGUI(y), name);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_white);
draw_set_alpha(1.0);

