// var mx = mouse_x,
//	my = mouse_y,
var mx = GetPositionXOnGUI(mouse_x),
	my = GetPositionYOnGUI(mouse_y),
	sx = draw.sx,
	sy = draw.sy,
	vi = point_in_rectangle(mx, my, sx, sy, sx + draw.dw, sy + draw.dh);

if (vi != curt.vi) {
	window_set_cursor(vi ? cr_beam : cr_default);
	curt.vi = vi;
}

var dc = draw.dc - 1;
if (dc < -30) {
	dc = 30;
	draw.re = true;
} else if (dc == 0) {
	draw.re = true;
}

draw.dc = dc;
	
#region update cursor (with mouse)
	
	if (mouse_check_button_pressed(keys.ml)) {
		curt.fo = vi;
		curt.se = -1;
		draw.dc = vi ? 30 : 0;
		draw.re = true;
		if (!vi) return;
		keyboard_string = "";
		textbox_check_minput(keyboard_check(keys.sh));
		curt.br = 5;
	}
	
#endregion

#region update y-offset (with mouse)

	if (vi) {

		var mc = mouse_wheel_up() - mouse_wheel_down();
		if (mc != 0) {
			var ox = draw.ox - draw.lh * mc,
				mw = string_width(curt.tx) - draw.dw;
			if (mw < 0) ox = 0;
			else ox = clamp(ox, 0, mw);
			draw.ox = ox;
			draw.re = true;
			return;
		}

	}

#endregion

if (!curt.fo) return;
		
#region get string
	
	var ks = keyboard_string;
	if (ks != "") {
		textbox_insert_string(ks);
		keyboard_string = "";
		return;
	}
	
#endregion
	
#region update mouse selector
	
	if (mouse_check_button(keys.ml)) {
		curt.br --;
		if (curt.br < 0) {
			textbox_check_minput(true);
			curt.br = 3;
		}
		return;
	}
	
#endregion

#region execute
	
	if (keyboard_check_pressed(keys.es) || keyboard_check_pressed(keys.en)) {
		curt.fn(curt.tx);
		return;
	}

#endregion
	
#region update cursor
	
	var hc = keyboard_check_pressed(keys.ri) - keyboard_check_pressed(keys.le);
	if (hc != 0) {
		curt.br = 40;
		textbox_update_cursor(hc, keyboard_check(keys.sh));
	}
		
	var ph = keyboard_check(keys.ri) - keyboard_check(keys.le);
	if (ph != 0) {
		curt.br --;
		if (curt.br < 0) {
			textbox_update_cursor(ph, keyboard_check(keys.sh));
			curt.br = 3;
		}
		return;
	}
		
#endregion
	
#region delete string
	
	var de = keyboard_check_pressed(keys.de);
	if (keyboard_check_pressed(keys.bs) || de) {
		curt.br = 40;
		textbox_delete_string(de);
	}
	
	var pe = keyboard_check(keys.de);
	if (keyboard_check(keys.bs) || pe) {
		curt.br --;
		if (curt.br < 0) {
			textbox_delete_string(pe);
			curt.br = 3;
		}
		return;
	}
	
#endregion
	
#region edit string
	
	if (keyboard_check(keys.ct)) {
			
		// Select all string.
		if (keyboard_check_pressed(keys.na)) {
			var le = string_length(curt.tx);
			if (le < 1) return;
			curt.cu = le;
			curt.se = 0;
			textbox_refresh_surface();
			return;
		}
			
		// Copy string.
		if (keyboard_check_pressed(keys.nc)) {
			textbox_copy_string();
			return;
		}
			
		// Cut string.
		if (keyboard_check_pressed(keys.nx)) {
			textbox_copy_string();
			textbox_delete_string(false);
			return;
		}
			
		// Paste string.
		if (keyboard_check_pressed(keys.nv)) {
			var cl = clipboard_has_text() ? clipboard_get_text() : global.clipboard;
			if (cl != "") textbox_insert_string(cl);
			return;
		}
			
		// Undo.
		if (keyboard_check_pressed(keys.nz)) {
			textbox_records_set(-1);
			return;
		}
			
		// Redo.
		if (keyboard_check_pressed(keys.ny)) {
			textbox_records_set(1);
			return;
		}
			
	}
	
#endregion
	
#region others
	
	// Go to the beginning.
	if (keyboard_check_pressed(keys.ho)) {
		var cu = curt.cu;
		if (cu == 0) return;
		curt.se = keyboard_check(keys.sh) ? cu : -1;
		curt.cu = 0;
		textbox_refresh_surface();
		return;
	}
			
	// Go to the end.
	if (keyboard_check_pressed(keys.ed)) {
		var le = string_length(curt.tx);
		if (le < 1) return;
		curt.se = keyboard_check(keys.sh) ? curt.cu : -1;
		curt.cu = le;
		textbox_refresh_surface();
		return;
	}
	
#endregion