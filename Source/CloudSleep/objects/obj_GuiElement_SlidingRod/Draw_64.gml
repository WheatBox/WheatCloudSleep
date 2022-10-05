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

var _draggingVarNum = undefined;
var _handleHightlight = false;
if(GUI_MouseGuiOnMe(x, rodTop - handleHeight / 2, x + width, rodBottom + handleHeight / 2)) {
	gMouseOnGUI = true;
	
	_handleHightlight = true;
	
	if(MouseLeftHold()) {
		var _mouseXGui = GetPositionXOnGUI(mouse_x);
		
		_draggingVarNum = variableMin + (_mouseXGui - rodLeft) / (rodRight - rodLeft) * (variableMax - variableMin);
		
		var _draggingVarNumAfterMyIntFunc = MyIntFunc(_draggingVarNum);
		_draggingVarNumAfterMyIntFunc ??= _draggingVarNum;
		_draggingVarNum = clamp(_draggingVarNumAfterMyIntFunc, variableMin, variableMax);
	} else {
		GUI_SetCursorHandpoint();
	}
}

var _varNum = 0;
switch(variableType) {
	case 0:
		if(variable_global_exists(variableName)) {
			_varNum = variable_global_get(variableName);
			
			if(_draggingVarNum != undefined) {
				variable_global_set(variableName, _draggingVarNum);
			}
		}
		break;
	case 1:
		if(CheckStructCanBeUse(variableStruct))
		if(variable_struct_exists(variableStruct, variableName)) {
			_varNum = variable_struct_get(variableStruct, variableName);
			
			if(_draggingVarNum != undefined) {
				variable_struct_set(variableStruct, variableName, _draggingVarNum);
			}
		}
		break;
	case 2:
		if(InstanceExists(variableIns))
		if(variable_instance_exists(variableIns, variableName)) {
			_varNum = variable_instance_get(variableIns, variableName);
			
			if(_draggingVarNum != undefined) {
				variable_instance_set(variableIns, variableName, _draggingVarNum);
			}
		}
		break;
}
if(is_real(_varNum) == false) {
	_varNum = 0;
}

var handleX = rodLeft + (_varNum - variableMin) / (variableMax - variableMin) * (rodRight - rodLeft);
draw_set_color(color);
GUI_DrawRectangle(handleX - handleWidth / 2, rodY - handleHeight / 2, handleX + handleWidth / 2, rodY + handleHeight / 2);

draw_set_color(c_white);
if(_handleHightlight) {
	draw_set_alpha(GUIHighLightAlpha);
	GUI_DrawRectangle(handleX - handleWidth / 2, rodY - handleHeight / 2, handleX + handleWidth / 2, rodY + handleHeight / 2);
}

draw_set_alpha(1.0);

GUI_DrawTextTransformed(x + 2, y, labelText + " " + string(_varNum) + "∈[" + string(variableMin) + "," + string(variableMax) + "]", 0.8, 0.8, 0, false);
