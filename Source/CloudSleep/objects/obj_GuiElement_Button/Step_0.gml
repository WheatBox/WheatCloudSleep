var labelTextWHalf = GUI_GetStringWidthHalf(labelText);
var labelTextHHalf = GUI_GetStringHeightHalf(labelText);

mouseOnMe = (width == undefined)
	? GUI_MouseGuiOnMe(x - labelTextWHalf, y - labelTextHHalf, x + labelTextWHalf, y + labelTextHHalf)
	: GUI_MouseGuiOnMe(x - width / 2, y - height / 2, x + width / 2, y + height / 2)


if(mouseOnMe == true){
	window_set_cursor(cr_handpoint);
	
	gMouseOnGUI = true;
	
	if(MouseLeftPressed()) {
		MyPressedFunction(MyPressedFunctionArgs);
	}
}

if(Disposable && (MouseLeftPressed() || MouseRightPressed())) {
	instance_destroy(id);
}

