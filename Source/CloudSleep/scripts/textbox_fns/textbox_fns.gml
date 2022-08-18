
/// @param string
function format_nowrap(s) {
	
	var r = string_replace_all(s, "\n", "");
		r = string_replace_all(r, "\r", "");
		r = string_replace_all(r, "\t", "");

	return r;

}

/// @param x
/// @param y
/// @param width
/// @param height
/// @param initial_text
/// @param placeholder
/// @param max_length
/// @param font
/// @param function
function textbox_create(x, y, w, h, n, p, m, t, f) {

	var i = instance_create_depth(0, 0, depth - 1, textbox);
	with (i) {
		draw.sx = x;					// x
		draw.sy = y;					// y
		draw.dw = w;					// width
		draw.dh = h;					// height
		draw.ft = t;					// font
		curt.ph = p;					// placeholder
		curt.ml = m;					// max length
		curt.fn = f;					// function
		textbox_insert_string(n);
	}

	return i;

}

/// @param instance
/// @param font_index
/// @param font_color
/// @param textbox_height
/// @param y_resive
function textbox_set_font(i, f, c, l, r) {

	with (i) {
		draw.ft = f;					// font
		draw.co = c;					// font color
		draw.lh = l;					// line height
		draw.ry = r;					// y resive
		textbox_refresh_surface();
	}
	
}

/// @param instance
/// @param x
/// @param y
/// @param offset?
function textbox_set_position(i, x, y, o) {

	with (i) {
		if (o) {
			draw.sx += x;				// +x
			draw.sy += y;				// +y
		} else {
			draw.sx = x;				// x
			draw.sy = y;				// y
			draw.re = true;
		}
	}

}

/// @param instance
function textbox_return(i) {
	
	return i.curt.tx;

}

/// @param text
/// @param cursor
function textbox_records_add(t, c) {
		
	var hr = curt.hr,
		cr = curt.cr + 1;

	if (cr < array_length(hr)) array_resize(hr, cr);
	array_push(hr, [t, c]);
		
	if (array_length(hr) > curt.rl) {
		array_delete(hr, 0, 1);
		cr -= 1;
	}

	curt.cr = cr;

}

/// @param cursor
function textbox_records_rec(c) {
	
	curt.hr[curt.cr][1] = c;
	
}

/// @param change
function textbox_records_set(c) {
	
	var hr = curt.hr,
		cr = curt.cr + c;

	if (cr < 0 || cr >= array_length(hr)) return;
	var li = hr[cr];
		
	curt.tx = li[0];
	curt.cr = cr;
	curt.cu = li[1];
	curt.se = -1;
	textbox_refresh_surface();
	
}

function textbox_refresh_surface() {

	var tx = curt.tx,
		cu = curt.cu,
		dw = draw.dw,
		ox = draw.ox;

	draw_set_font(draw.ft);

	var cw = string_width(string_copy(tx, 1, cu)),
		ow = cw - ox;
			
	if (ow < 0) ox = cw;
	else if (ow > dw) ox = cw - dw;
	
	var mw = string_width(tx) - dw;
	if (mw < 0) ox = 0;
	else ox = clamp(ox, 0, mw);
	
	draw.ox = ox;
	draw.dc = 30;
	draw.re = true;
	
}

function textbox_max_length() {
	
	var ml = curt.ml;
	if (ml > 0) {
		var tx = curt.tx;
		if (string_length(tx) > ml) {
			curt.tx = string_copy(tx, 1, ml);
			if (curt.cu > ml) curt.cu = ml;
		}
	}

}

/// @param string
function textbox_insert_string(s) {
		
	if (curt.se > -1) textbox_delete_string(false);
		
	var tx = curt.tx,
		cu = curt.cu,
		ns = format_nowrap(s);
		
	tx = string_insert(ns, tx, cu + 1);
	cu += string_length(ns);

	curt.tx = tx;
	curt.cu = cu;
	textbox_max_length();
	textbox_records_add(tx, cu);
	textbox_refresh_surface();

}

/// @param delete_key?
function textbox_delete_string(d) {

	var tx = curt.tx,
		cu = curt.cu,
		se = curt.se;

	if (se > -1) {
		var co = abs(cu - se);
		cu = min(cu, se);
		tx = string_delete(tx, cu + 1, co);
		curt.se = -1;
	} else {
		if (d) {
			tx = string_delete(tx, cu + 1, 1);
		} else {
			if (cu < 1) return;
			tx = string_delete(tx, cu, 1);
			cu -= 1;
		}
	}

	curt.tx = tx;
	curt.cu = cu;
	textbox_records_add(tx, cu);
	textbox_refresh_surface();

}

function textbox_copy_string() {
		
	var se = curt.se;
	if (se < 0) return;

	var tx = curt.tx,
		cu = curt.cu;

	tx = string_copy(tx, min(cu, se) + 1, abs(cu - se));
	global.clipboard = tx;
	clipboard_set_text(tx);
	
}

/// @param change
function textbox_check_hinput(c) {
	
	var ls = string_length(curt.tx),
		cu = curt.cu + c;

	if (cu < 0) cu = 0;
	else if (cu > ls) cu = ls;
	textbox_records_rec(cu);
	
	return cu;
	
}

/// @param select?
function textbox_check_minput(s) {

	if (curt.tx == "") return;
	draw_set_font(draw.ft);

	var tx = curt.tx,
		cu = curt.cu,
		cw = string_width(string_copy(tx, 1, cu)) - draw.ox - (mouse_x - draw.sx),
		i = cu,
		l = string_length(tx);
	
	if (cw < 0) {
		cw *= -1;
		if (cu == 0) cu = 1;
		repeat (l) {
			var ra = cw - string_width(string_copy(tx, i + 1, 1)) / 2;
			if (string_width(string_copy(tx, cu, i - cu)) >= ra) break;
			i ++;
		}
	} else {
		repeat (l) {
			var ra = cw - string_width(string_copy(tx, i, 1)) / 2;
			if (string_width(string_copy(tx, i, cu - i)) >= ra) break;
			i --;
		}
	}
	
	cu = clamp(i, 0, l);

	if (s) {
		var se = curt.se;
		if (se < 0) se = curt.cu;
		if (cu == se) se = -1;
		curt.se = se;
	}

	curt.cu = cu;
	textbox_records_rec(cu);
	textbox_refresh_surface();
	
}

/// @param change
/// @param select?
function textbox_update_cursor(c, s) {
	
	if (s) {
		var cu = curt.cu,
			se = curt.se;
		if (se < 0) se = cu;
		cu = textbox_check_hinput(c);
		if (cu == se) se = -1;
		curt.cu = cu;
		curt.se = se;
	} else {
		if (curt.se > -1) {
			curt.se = -1;
			return;
		}
		curt.cu = textbox_check_hinput(c);
	}
	
	textbox_refresh_surface();
		
}