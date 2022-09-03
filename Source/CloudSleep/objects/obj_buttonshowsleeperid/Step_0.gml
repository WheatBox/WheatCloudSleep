mouseOnMe = GUI_MouseGuiOnMe(x - width / 2, y - height / 2, x + width / 2, y + height / 2);

if(mouseOnMe) {
	gMouseOnGUI = true;
	
	if(mouse_check_button_pressed(mb_left)) {
		gShowSleeperId = !gShowSleeperId;
	}
	
	image_alpha = lerp(image_alpha, 1.0, 0.1);
} else {
	image_alpha = lerp(image_alpha, 0.1, 0.1);
}

