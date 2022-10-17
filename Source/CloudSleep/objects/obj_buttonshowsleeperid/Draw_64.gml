// SaveDrawSettings();

if(gShowSleeperId == true) {
	labelText = "点我关闭显示 睡客ID";
} else {
	labelText = "点我开启显示 睡客ID";
}

// GUI_DrawLabel_ext(labelText, x, y, width / 2, height / 2, false, , image_alpha);

draw_set_color(GUIDefaultColor);
draw_set_alpha(image_alpha);

GUI_DrawRectangle(x - width / 2, y - height / 2, x + width / 2, y + height / 2, false);
draw_set_color(c_white);
draw_set_alpha(image_alpha / 2 + 0.5);
GUI_DrawText(x, y, labelText, true);

draw_set_alpha(1.0);

// LoadDrawSettings();