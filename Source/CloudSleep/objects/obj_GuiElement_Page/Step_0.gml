if(working == false) {
	visible = false;
} else {
	visible = true;
	
	if(GUI_MouseGuiOnMe(x, y, x + width, y + height)) {
		gMouseOnGUI = true;
		
		if(mouse_wheel_up()) {
			if(scrollY > 0) {
				MyScrollElements(scrollYSpeed);
				scrollY -= scrollYSpeed;
			}
		} else if(mouse_wheel_down()) {
			if(InstanceExists(vecChildElements.back()))
			if(0 + scrollYSpeed * 2 < vecChildElements.back().bbox_top) {
				MyScrollElements(-scrollYSpeed);
				scrollY += scrollYSpeed;
			}
		}
	}
}

