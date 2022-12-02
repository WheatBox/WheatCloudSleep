if(working) {
	yAdd = lerp(yAdd, yAddEnd, 0.2);
} else {
	yAdd = lerp(yAdd, yAddBegin, 0.2);
}

x = GuiWidth() + xAdd;
y = GuiHeight() + yAdd;

buttonHomeX = x + 200;
buttonHomeY = y + 432 + 22;

mouseOnScreen = GUI_MouseGuiOnMe(x, y, x + screenWidth, y + screenHeight);
if(GUI_MouseGuiOnMe(x - 16, y - 48, x + screenWidth + 16, y + screenHeight + 48)) {
	gMouseOnGUI = true;
	gMouseOnOurPhone = true;
	
	mouseOnMe = true;
} else {
	mouseOnMe = false;
}

if(mouseDragging == false) {
	buttonHomeMouseOnMe = MyCheckMouseOnButtonHome();
	if(buttonHomeMouseOnMe) {
		GUI_SetCursorHandpoint();
	}
}

if(mouseOnMe && mouseOnScreen == false && buttonHomeMouseOnMe == false) {
	if(MouseLeftPressed()) {
		mouseDragXOff = GetPositionXOnGUI(mouse_x) - x;
		mouseDragYOff = GetPositionYOnGUI(mouse_y) - y;
		
		mouseDragging = true;
	}
}

if(mouseDragging) {
	gMouseOnGUI = true;
	gMouseOnOurPhone = true;
	
	if(MouseLeftHold() == false) {
		mouseDragging = false;
	} else {
		x = GetPositionXOnGUI(mouse_x) - mouseDragXOff;
		y = GetPositionYOnGUI(mouse_y) - mouseDragYOff;
		
		xAdd = x - GuiWidth();
		yAdd = y - GuiHeight();
		yAddEnd = yAdd;
		
		buttonHomeX = x + 200;
		buttonHomeY = y + 432 + 22;
	}
}

gOurPhoneX = x;
gOurPhoneY = y;
