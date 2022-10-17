// SaveDrawSettings();

draw_set_color(GUIDefaultColor);
draw_set_alpha(GUIDefaultAlpha);
GUI_DrawRectangle(x, y, x + width, y + height);

if(scrollY < 0) {
	labelAlpha = lerp(labelAlpha, 0, 0.1);
} else {
	labelAlpha = lerp(labelAlpha, 1, 0.1);
}


var _scrollBarX = x + width + 1;
var _scrollBarRight = _scrollBarX + scrollBarWidth;
var _scrollBarY = y + -scrollY / childElementsBottom * height;
var _scrollBarBottom = y + (-scrollY + height) / childElementsBottom * height;

var _scrollBarBgY = y;
var _scrollBarBgBottom = y + height;

var _scrollBarHighlight = false;

if(GUI_MouseGuiOnMe(_scrollBarX, _scrollBarBgY, _scrollBarX + scrollBarWidthMax, _scrollBarBgBottom)) {
	gMouseOnGUI = true;
	
	scrollBarWidth = lerp(scrollBarWidth, scrollBarWidthMax, 0.2);
	
	var _mouseYGui = GetPositionYOnGUI(mouse_y);
	if(_mouseYGui > _scrollBarY && _mouseYGui < _scrollBarBottom) {
		_scrollBarHighlight = true;
		
		if(scrollBarIsDragging == false)
			GUI_SetCursorHandpoint();
	}
	
	if(MouseLeftPressed()) {
		scrollBarIsDragging = true;
		
		if(_mouseYGui > _scrollBarY && _mouseYGui < _scrollBarBottom) {
			scrollBarDraggingOffY = _mouseYGui - _scrollBarY;
		} else {
			scrollBarDraggingOffY = (_scrollBarBottom - _scrollBarY) / 2;
		}
	}
} else {
	scrollBarWidth = lerp(scrollBarWidth, scrollBarWidthMin, 0.2);
}

if(scrollBarIsDragging) {
	gMouseOnGUI = true;
	_scrollBarHighlight = true;
	
	if(MouseLeftHold() == false) {
		scrollBarIsDragging = false;
	} else {
		scrollY = ((GetPositionYOnGUI(mouse_y) - y - scrollBarDraggingOffY) / height * childElementsBottom);
		
		if(scrollY + height > childElementsBottom) scrollY = childElementsBottom - height;
		if(scrollY < 0) scrollY = 0;
		
		scrollY = -scrollY;
	}
}

_scrollBarRight = _scrollBarX + scrollBarWidth;

draw_set_color(GUIDefaultColor);
draw_set_alpha(1.0);
GUI_DrawRectangle(_scrollBarX, _scrollBarBgY, _scrollBarRight, _scrollBarBgBottom, false);

draw_set_color(c_white);
draw_set_alpha(GUIDefaultAlpha);
GUI_DrawRectangle(_scrollBarX, _scrollBarY, _scrollBarRight, _scrollBarBottom, false);
if(_scrollBarHighlight) {
	draw_set_alpha(GUIHighLightAlpha);
	GUI_DrawRectangle(_scrollBarX, _scrollBarY, _scrollBarRight, _scrollBarBottom, false);
}

draw_set_color(c_white);
draw_set_alpha(1.0);


// LoadDrawSettings();

