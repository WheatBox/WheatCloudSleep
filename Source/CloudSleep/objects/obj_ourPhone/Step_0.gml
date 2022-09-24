if(working) {
	yAdd = lerp(yAdd, yAddEnd, 0.2);
} else {
	yAdd = lerp(yAdd, yAddBegin, 0.2);
}

x = GuiWidth() + xAdd;
y = GuiHeight() + yAdd;

if(GUI_MouseGuiOnMe(bbox_left, bbox_top, bbox_right, bbox_bottom)) {
	gMouseOnGUI = true;
	
	mouseOnMe = true;
} else {
	mouseOnMe = false;
}

buttonHomeMouseOnMe = MyCheckMouseOnButtonHome();
if(buttonHomeMouseOnMe) {
	GUI_SetCursorHandpoint();
}
