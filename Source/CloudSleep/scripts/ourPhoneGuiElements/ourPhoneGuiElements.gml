function OurPhoneGUI_MouseGuiOnMe(left, top, right, bottom) {
	var mx = gMouseOnOurPhoneX;
	var my = gMouseOnOurPhoneY;
	var x1 = left;
	var y1 = top;
	var x2 = right;
	var y2 = bottom;
	if(point_in_rectangle(mx, my, x1, y1, x2, y2)) {
		return true;
	}
	return false;
}


function OurPhoneGuiElement_TextBox(_x, _y, _width, _height, _maxStringLength = -1, _placeHolder = "", _textScale = 1.0) constructor {
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	maxStringLength = _maxStringLength; // 若为 -1 则为自动
	
	placeHolder = _placeHolder;
	
	textScale = _textScale;
	
	haveFocus = false;
	
	myString = "";
	myDrawString = myString;
	
	myCursorX = 0;
	myCursorY = 0;
	myCursorHeight = string_height("乐") * textScale;
	myCursorShow = false;
	myCursorShakeTimeMax = 30;
	myCursorShakeTime = myCursorShakeTimeMax;
	
	static Draw = function() {
		draw_set_color(c_black);
		draw_set_alpha(1);
		
		GUI_DrawRectangle(x, y, x + width, y + height, true);
		
		if(haveFocus) {
			if(myCursorShow) {
				draw_line_width(x + myCursorX, y + myCursorY, x + myCursorX, y + myCursorY + myCursorHeight, 1);
			}
			myCursorShakeTime--;
			if(myCursorShakeTime < 0) {
				myCursorShakeTime = myCursorShakeTimeMax;
				myCursorShow = !myCursorShow;
			}
		}
		
		if(myString == "") {
			draw_set_color(c_gray);
			GUI_DrawTextTransformed(x, y, placeHolder, textScale, textScale, 0, false);
		} else {
			GUI_DrawTextTransformed(x, y, myDrawString, textScale, textScale, 0, false);
		}
		
		draw_set_color(c_white);
	}
	
	static CheckAndSetFocus = function() {
		if(OurPhoneGUI_MouseGuiOnMe(x, y, x + width, y + height)) {
			GUI_SetCursorBeam();
			
			if(MouseLeftPressed()) {
				if(haveFocus == false) {
					keyboard_string = "";
				}
				
				haveFocus = true;
				
				myCursorShow = true;
				myCursorShakeTime = myCursorShakeTimeMax;
			}
		} else {
			if(MouseLeftPressed()) {
				haveFocus = false;
				
				myCursorShow = false;
			}
		}
	}
	
	myBackSpaceHoldingTime = 0;
	myBackSpaceHoldingTimeDeadZone = 30;
	static TypingWords = function() {
		if(!haveFocus) {
			myBackSpaceHoldingTime = 0;
			return;
		}
		
		var _myStringChanged = false;
		
		if(keyboard_check(vk_control) && keyboard_check_pressed(ord("V"))) {
			myString += clipboard_get_text();
			
			_myStringChanged = true;
		}
		if(keyboard_string != "") {
			myString += keyboard_string;
			keyboard_string = "";
			
			myCursorShow = true;
			myCursorShakeTime = myCursorShakeTimeMax;
			
			_myStringChanged = true;
		}
		if(keyboard_check(vk_backspace)) {
			if(myBackSpaceHoldingTime == 0
				|| (
					myBackSpaceHoldingTime >= myBackSpaceHoldingTimeDeadZone
					&& myBackSpaceHoldingTime % 2 == 0
				)) {
				myString = string_copy(myString, 1, string_length(myString) - 1);
			}
			myBackSpaceHoldingTime++;
			
			_myStringChanged = true;
		} else {
			myBackSpaceHoldingTime = 0;
		}
		
		if(_myStringChanged = true) {
			if(maxStringLength != -1) {
				if(string_length(myString) > maxStringLength) {
					myString = string_copy(myString, 1, maxStringLength);
				}
				
				MyAlignCursorPosAndAutoWarp();
			} else {
				MyAlignCursorPosAndAutoWarp();
				
				while(string_height(myDrawString) * textScale > height && myString != "") {
					var _lenTemp = string_length(myDrawString) - string_last_pos("\n", myDrawString);
					
					myString = string_copy(myString, 1, string_length(myString) - _lenTemp);
					
					MyAlignCursorPosAndAutoWarp();
				}
			}
		}
	}
	
	static WorkEasy = function() {
		CheckAndSetFocus();
		TypingWords();
		Draw();
	}
	
	static MyAlignCursorPosAndAutoWarp = function() {
		myDrawString = StringAutoWarp(myString, width / textScale);
		
		var _lastLine = string_last_pos("\n", myDrawString);
		myCursorX = string_width(string_copy(myDrawString, _lastLine + 1, string_length(myDrawString) - _lastLine)) * textScale;
		myCursorY = string_height("乐") * textScale * string_count("\n", myDrawString);
		myCursorHeight = string_height("乐") * textScale;
	}
	
	static GetContent = function() {
		return myString;
	}
	
	static ClearContent = function() {
		myString = "";
		MyAlignCursorPosAndAutoWarp();
	}
}

function OurPhoneGuiElement_Button(_x, _y, _width, _height, _labelText, _FuncPressedArgs = [], _FuncPressed = function(args) {}, _color = c_black, _alpha = 1.0, _textColor = c_white, _textScale = 1.0, _textOnCenter = true) constructor {
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	
	labelText = _labelText;
	
	MyFuncPressedArgs = _FuncPressedArgs;
	MyFuncPressed = _FuncPressed;
	
	color = _color;
	alpha = _alpha;
	textColor = _textColor;
	textScale = _textScale;
	textOnCenter = _textOnCenter;
	
	static Draw = function(_highlight = false) {
		draw_set_color(color);
		draw_set_alpha(alpha);
		
		GUI_DrawRectangle(x, y, x + width, y + height, false);
		
		draw_set_color(textColor);
		GUI_DrawTextTransformed(x + width / 2, y + height / 2, labelText, textScale, textScale, 0, textOnCenter);
		
		draw_set_color(c_white);
		
		if(_highlight) {
			draw_set_alpha(GUIHighLightAlpha);
			GUI_DrawRectangle(x, y, x + width, y + height, false);
		}
		draw_set_alpha(1);
	}
	
	/// @desc 返回值：-1 = 鼠标没有触及，0 = 鼠标在上面没按下，1 = 鼠标按下了
	static CheckAndWorkPressed = function() {
		if(OurPhoneGUI_MouseGuiOnMe(x, y, x + width, y + height)) {
			GUI_SetCursorHandpoint();
			
			if(MouseLeftPressed()) {
				MyFuncPressed(MyFuncPressedArgs);
				
				return 1;
			} else {
				return 0;
			}
		} else {
			return -1;
		}
	}
	
	static WorkEasy = function() {
		var _highlight = CheckAndWorkPressed();
		Draw(_highlight != -1);
	}
}
