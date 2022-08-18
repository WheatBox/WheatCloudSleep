global.clipboard = "";

draw = {
	su : noone,				// surface
	re : false,				// refresh surface
	dc : 30,				// display cursor
	ft : noone,				// font
	co : c_black,			// font color
	sx : 32,				// x start
	sy : 32,				// y start
	dw : 160,				// draw width
	dh : 38,				// draw height
	ox : 0,					// x offset
	ry : 0,					// y resive
	lh : 22					// line height
}

curt = {
	fo : false,				// focus
	vi : false,				// view
	tx : "",				// text
	ph : "",				// placeholder
	cu : 0,					// cursor
	se : -1,				// select
	ml : 80,				// max length
	hr : [],				// historic records
	rl : 64,				// records upper limit
	cr : -1,				// records cursor
	br : 0
}

keys = {
	ho : vk_home,			// home
	ed : vk_end,			// end
	bs : vk_backspace,		// backspace
	de : vk_delete,			// delete
	ct : vk_control,		// control
	na : ord("A"),			// A
	nx : ord("X"),			// X
	nc : ord("C"),			// C
	nv : ord("V"),			// V
	nz : ord("Z"),			// Z
	ny : ord("Y"),			// Y
	le : vk_left,			// left
	ri : vk_right,			// right
	ml : mb_left,			// mouse left
	en : vk_enter,			// enter
	sh : vk_shift,			// shift
	es : vk_escape			// escape
}

keyboard_string = "";