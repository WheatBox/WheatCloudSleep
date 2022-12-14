#macro GUIDepth -10000
#macro GUIPageDepth -9900
#macro GUIDragObjDepth -10100
#macro GUIMessageDepth -10200

#macro GUIDefaultColor #000037
#macro GUIDangerousColor c_red
#macro GUIWarningColor c_yellow

#macro GUIDefaultAlpha 0.6
#macro GUIHighLightAlpha 0.3

globalvar gMouseOnGUI, gMouseDraggingSlidingRodIns;
gMouseOnGUI = false;
gMouseDraggingSlidingRodIns = noone;

// 关于该变量的相关设置在 obj_camera 里
globalvar __MouseOnGUIBackswing;
__MouseOnGUIBackswing = 0;

#macro IsMouseOnGUI (__MouseOnGUIBackswing > 0)

globalvar __halignTemp, __valignTemp, __colTemp, __alphaTemp;
__halignTemp = fa_left;
__valignTemp = fa_top;
__colTemp = c_white;
__alphaTemp = 1.0;

function SaveDrawSettings() {
	__halignTemp = draw_get_halign();
	__valignTemp = draw_get_valign();
	__colTemp = draw_get_color();
	__alphaTemp = draw_get_alpha();
}

function LoadDrawSettings() {
	draw_set_halign(__halignTemp);
	draw_set_valign(__valignTemp);
	draw_set_color(__colTemp);
	draw_set_alpha(__alphaTemp);
}


function GUI_GetStringWidth(text) {
	return string_width(text);
}

function GUI_GetStringHeight(text) {
	return string_height(text);
}

function GUI_GetStringWidthHalf(text) {
	return string_width(text) / 2;
}

function GUI_GetStringHeightHalf(text) {
	return string_height(text) / 2;
}

function GUI_MouseGuiOnMe(left, top, right, bottom) {
	var mx = GetPositionXOnGUI(mouse_x);
	var my = GetPositionYOnGUI(mouse_y);
	var x1 = left;
	var y1 = top;
	var x2 = right;
	var y2 = bottom;
	if(point_in_rectangle(mx, my, x1, y1, x2, y2)) {
		return true;
	}
	return false;
}

function GUI_MouseGuiOnMe_Radius(_x, _y, _radius) {
	var mx = GetPositionXOnGUI(mouse_x);
	var my = GetPositionYOnGUI(mouse_y);
	var x1 = _x - _radius;
	var y1 = _y - _radius;
	var x2 = _x + _radius;
	var y2 = _y + _radius;
	if(point_in_rectangle(mx, my, x1, y1, x2, y2)) {
		return true;
	}
	return false;
}

function GUI_DrawText(_xGui, _yGui, str, onCenter = false) {
	if(onCenter) {
		var ha = draw_get_halign();
		var va = draw_get_valign();
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text(_xGui, _yGui, str);
		
		draw_set_halign(ha);
		draw_set_valign(va);
	} else {
		draw_text(_xGui, _yGui, str);
	}
}

function GUI_DrawTextTransformed(_xGui, _yGui, str, xscale, yscale, angle, onCenter = false) {
	if(onCenter) {
		var ha = draw_get_halign();
		var va = draw_get_valign();
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text_transformed(_xGui, _yGui, str, xscale, yscale, angle);
		
		draw_set_halign(ha);
		draw_set_valign(va);
	} else {
		draw_text_transformed(_xGui, _yGui, str, xscale, yscale, angle);
	}
}

function GUI_DrawRectangle(left, top, right, bottom, outline = false) {
	draw_rectangle(
		/*GetPositionXOnGUI(left),
		GetPositionYOnGUI(top),
		GetPositionXOnGUI(right),
		GetPositionYOnGUI(bottom),*/
		left, top, right, bottom,
		outline
	);
}

function GUI_DrawRectangle_Radius(_x, _y, _radius, outline = false) {
	draw_rectangle(
		_x - _radius, _y - _radius, _x + _radius, _y + _radius,
		outline
	);
}

function GUI_DrawLabel(text, _xGui, _yGui, highLight = false) {
	GUI_DrawLabel_ext(text, _xGui, _yGui, , , highLight);
}

function GUI_DrawLabel_ext(text, _xGui, _yGui, _widthHalf = undefined, _heightHalf = undefined, highLight = false, _color = GUIDefaultColor, _alpha = GUIDefaultAlpha) {
	var _x = _xGui;
	var _y = _yGui;
	
	var halignTemp = draw_get_halign();
	var valignTemp = draw_get_valign();
	var colTemp = draw_get_color();
	var alphaTemp = draw_get_alpha();
	
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_color(_color);
	draw_set_alpha(_alpha);
	
	var strWHalf = ((_widthHalf == undefined) ? GUI_GetStringWidthHalf(text) : _widthHalf);
	var strHHalf = ((_widthHalf == undefined) ? GUI_GetStringHeightHalf(text) : _heightHalf);
	GUI_DrawRectangle(_x - strWHalf, _y - strHHalf, _x + strWHalf, _y + strHHalf, false);
	
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	
	GUI_DrawText(_x, _y, text);
	
	if(highLight) {
		draw_set_alpha(GUIHighLightAlpha);
		GUI_DrawRectangle(_x - strWHalf, _y - strHHalf, _x + strWHalf, _y + strHHalf, false);
	}
	
	
	draw_set_halign(halignTemp);
	draw_set_valign(valignTemp);
	draw_set_color(colTemp);
	draw_set_alpha(alphaTemp);
}

function GUI_DrawSprite(spr, subimg, _xGui, _yGui) {
	draw_sprite(spr, subimg, _xGui, _yGui);
}

function GUI_DrawSprite_ext(spr, subimg, _xGui, _yGui, xscale, yscale, rot, col, alpha) {
	draw_sprite_ext(spr, subimg, _xGui, _yGui, xscale, yscale, rot, col, alpha);
}

function GUI_DrawSurface(surf, _xGui, _yGui) {
	draw_surface(surf, _xGui, _yGui);
}

function GUI_DrawSurface_ext(surf, _xGui, _yGui, xscale, yscale, rot, col, alpha) {
	draw_surface_ext(surf, _xGui, _yGui, xscale, yscale, rot, col, alpha);
}


globalvar __CursorTEMP;
__CursorTEMP = cr_default;
function GUI_SetCursorHandpoint() {
	var curCursor = window_get_cursor();
	if(
		curCursor != cr_handpoint
		&& curCursor != cr_beam
	) {
		window_set_cursor(cr_handpoint);
	}
	__CursorTEMP = cr_handpoint;
}
function GUI_SetCursorBeam() {
	var curCursor = window_get_cursor();
	if(
		curCursor != cr_beam
	) {
		window_set_cursor(cr_beam);
	}
	__CursorTEMP = cr_beam;
}
function GUI_SetCursorDefault() {
	var curCursor = window_get_cursor();
	if(
		curCursor == cr_handpoint
		|| curCursor == cr_beam
	) {
		// 等到下一帧看看 GUI_SetCursorHandpoint(); 会不会被再次触发（也就是鼠标依然在按钮上）
		// 如果再次触发，那么忽略，进行下一次检查的准备（__CursorTEMP = cr_default）
		if(__CursorTEMP == cr_default) {
			window_set_cursor(__CursorTEMP);
		} else {
			__CursorTEMP = cr_default;
		}
	}
}

