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


function OurPhoneGuiElement_TextBox(_x, _y, _width, _height, _maxStringLength, _placeHolder) constructor {
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	maxStringLength = _maxStringLength;
	
	placeHolder = _placeHolder;
	
	haveFocus = false;
	
	myString = "";
	myDrawString = myString;
	
	myCursorX = 0;
	myCursorY = 0;
	myCursorHeight = string_height("乐");
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
			GUI_DrawText(x, y, placeHolder, false);
		} else {
			GUI_DrawText(x, y, myDrawString, false);
		}
		
		draw_set_color(c_white);
	}
	
	static CheckAndSetFocus = function() {
		if(OurPhoneGUI_MouseGuiOnMe(x, y, x + width, y + height)) {
			GUI_SetCursorBeam();
			
			if(MouseLeftPressed()) {
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
			if(string_length(myString) > maxStringLength) {
				myString = string_copy(myString, 1, maxStringLength);
			}
		}
		
		if(_myStringChanged) {
			MyAlignCursorPosAndAutoWarp();
		}
	}
	
	static WorkEasy = function() {
		CheckAndSetFocus();
		TypingWords();
		Draw();
	}
	
	static MyAlignCursorPosAndAutoWarp = function() {
		myDrawString = myString;
		var _l = 1, _sublen = 1, _lines = 0;
		for(var i = 0; i < string_length(myString); i++) {
			if(string_width(string_copy(myString, _l, _sublen + 1)) > width) {
				myDrawString = string_insert("\n", myDrawString, _l + _sublen + _lines);
				_l += _sublen;
				_sublen = 1;
				_lines++;
			} else {
				_sublen++;
			}
		}
		
		var _lastLine = string_last_pos("\n", myDrawString);
		myCursorX = string_width(string_copy(myDrawString, _lastLine + 1, string_length(myDrawString) - _lastLine));
		myCursorY = string_height("乐") * string_count("\n", myDrawString);
		myCursorHeight = string_height("乐");
	}
	
	static GetContent = function() {
		return myString;
	}
	
	static ClearContent = function() {
		myString = "";
		MyAlignCursorPosAndAutoWarp();
	}
}