SaveDrawSettings();

if(gShowSleeperId == true) {
	labelText = "点我关闭显示 睡客ID";
} else {
	labelText = "点我开启显示 睡客ID";
}

GUI_DrawLabel_ext(labelText, x, y, width / 2, height / 2, false,, image_alpha);

LoadDrawSettings();