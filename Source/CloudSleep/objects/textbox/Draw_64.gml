
var su = draw.su,
	sx = draw.sx,
	sy = draw.sy,
	dw = draw.dw,
	dh = draw.dh;

if (!surface_exists(su)) {
	su = surface_create(dw + 1, dh + 1);
	draw.su = su;
	draw.re = true;
}

draw_set_color(draw.co);
draw_rectangle(sx - 1, sy - 1, sx + dw + 1, sy + dh + 1, true);

if (draw.re) {

	var co = draw.co,
		ox = draw.ox,
		lh = draw.lh,
		tx = curt.tx,
		cu = curt.cu,
		se = curt.se,
		dy = (dh - lh) / 2;
		
	surface_set_target(su);
	draw_clear_alpha(co, 0);
		
	draw_set_font(draw.ft);
	draw_set_color(co);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	
	#region draw selected

		if (se > -1) {
			var d0 = string_width(string_copy(tx, 1, se)) - ox,
				d1 = string_width(string_copy(tx, 1, cu)) - ox;
			draw_set_alpha(0.6);
			draw_rectangle(d0, dy, d1, dy + lh, false);
			draw_set_alpha(1);
		}

	#endregion
	
	#region draw text
	
		if (tx == "") {
			draw_set_alpha(0.6);
			draw_text(-ox, dy + draw.ry, curt.ph);
			draw_set_alpha(1);
		} else {
			draw_text(-ox, dy + draw.ry, tx);
		}

	#endregion
	
	#region draw cursor

		if (curt.fo && draw.dc > 0) {
			var dx = string_width(string_copy(tx, 1, cu)) - ox;
			draw_rectangle(dx, dy, dx, dy + lh, false);
		}

	#endregion

	surface_reset_target();
	draw.re = false;

}

draw_surface(su, sx, sy);