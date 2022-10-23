draw_set_color(color);
draw_set_alpha(GUIDefaultAlpha);

GUI_DrawRectangle(x, y, x + width, y + height, false);

draw_set_color(c_black);

var rodY = y + height - handleHeight / 2;
var rodLeft = x + handleWidth / 2;
var rodTop = rodY - 4;
var rodRight = x + width - handleWidth / 2;
var rodBottom = rodY + 4;
GUI_DrawRectangle(rodLeft, rodTop, rodRight, rodBottom, false);

var _mouseXGui = GetPositionXOnGUI(mouse_x);

var _draggingVarNum = undefined;
var _handleHightlight = false;
if((gMouseDraggingSlidingRodIns == id || gMouseDraggingSlidingRodIns == noone) && GUI_MouseGuiOnMe(x, rodTop - handleHeight / 2, x + width, rodBottom + handleHeight / 2)) {
	gMouseOnGUI = true;
	gMouseDraggingSlidingRodIns = id;
	
	_handleHightlight = true;
	
	if(MouseLeftHold()) {
		_draggingVarNum = variableMin + (_mouseXGui - rodLeft) / (rodRight - rodLeft) * (variableMax - variableMin);
		
		var _draggingVarNumAfterMyIntFunc = MyIntFunc(_draggingVarNum);
		_draggingVarNumAfterMyIntFunc ??= _draggingVarNum;
		_draggingVarNum = clamp(_draggingVarNumAfterMyIntFunc, variableMin, variableMax);
	} else {
		GUI_SetCursorHandpoint();
		
		gMouseDraggingSlidingRodIns = noone;
	}
} else if(gMouseDraggingSlidingRodIns == id)
	if(MouseLeftHold() == false)
		gMouseDraggingSlidingRodIns = noone;

var _varNum = pMyVar.value();
_varNum ??= 0;
if(_draggingVarNum != undefined) {
	pMyVar.set(_draggingVarNum);
}

var handleX = rodLeft + (_varNum - variableMin) / (variableMax - variableMin) * (rodRight - rodLeft);
draw_set_color(color);
GUI_DrawRectangle(handleX - handleWidth / 2, rodY - handleHeight / 2, handleX + handleWidth / 2, rodY + handleHeight / 2);

if(gMouseDraggingSlidingRodIns == id) {
	var _windowMouseX = window_mouse_get_x();
	
	window_mouse_set(_windowMouseX, rodY);
	
	if(_windowMouseX < rodLeft)
		window_mouse_set(rodLeft, rodY);
	else if(_windowMouseX > rodRight)
		window_mouse_set(rodRight, rodY);
}

draw_set_color(c_white);
if(_handleHightlight) {
	draw_set_alpha(GUIHighLightAlpha);
	GUI_DrawRectangle(handleX - handleWidth / 2, rodY - handleHeight / 2, handleX + handleWidth / 2, rodY + handleHeight / 2);
}

draw_set_alpha(1.0);

GUI_DrawTextTransformed(x + 2, y, labelText + " " + string(_varNum) + "∈[" + string(variableMin) + "," + string(variableMax) + "]", 0.8, 0.8, 0, false);
