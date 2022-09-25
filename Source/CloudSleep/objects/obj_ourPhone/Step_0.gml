if(working) {
	yAdd = lerp(yAdd, yAddEnd, 0.2);
} else {
	yAdd = lerp(yAdd, yAddBegin, 0.2);
}

x = GuiWidth() + xAdd;
y = GuiHeight() + yAdd;

if(GUI_MouseGuiOnMe(x, y, x + screenWidth, y + screenHeight)) {
	gMouseOnGUI = true;
	
	mouseOnMe = true;
} else {
	mouseOnMe = false;
}

buttonHomeMouseOnMe = MyCheckMouseOnButtonHome();
if(buttonHomeMouseOnMe) {
	GUI_SetCursorHandpoint();
}
