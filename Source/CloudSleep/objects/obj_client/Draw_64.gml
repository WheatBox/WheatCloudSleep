draw_set_color(#B3CCB6);
draw_set_alpha(0.5);

draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

if(myTextBox != noone) {
	draw_set_color(c_white);
	draw_set_alpha(0.5);
	draw_rectangle(12, 720 - 48, 12 + 950, 720 - 48 + 28, false);
}

draw_set_alpha(1.0);
draw_set_color(c_white);

