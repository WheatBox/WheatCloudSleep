/*draw_set_color(#B3CCB6);
if(IsNight()) {
	draw_set_alpha(0.3);
} else {
	draw_set_alpha(0.5);
}

draw_rectangle(0, 0, GuiWidth(), GuiHeight(), false);*/

if(myTextBox != noone) {
	draw_set_color(c_white);
	draw_set_alpha(0.5);
	draw_rectangle(12, GuiHeight() - 48, 12 + 950, GuiHeight() - 48 + 28, false);
}

if(DEBUGMODE) {
	draw_set_alpha(1.0);
	draw_set_color(c_black);
	draw_text_transformed(0, 18, debugStrBufs, 0.7, 0.7, 0);
}

draw_set_alpha(1.0);
draw_set_color(c_white);

