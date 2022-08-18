var left = x - 48;
var right = x + 48;
var top = y - 24;
var bottom = y + 24;
if(mouse_x >= left && mouse_y >= top && mouse_x <= right && mouse_y <= bottom) {
	if(mouse_check_button_pressed(mb_left)) {
		if(instance_exists(obj_inputMyNameTextbox)) {
			myName = textbox_return(obj_inputMyNameTextbox.myTextbox);
			if(string_length(myName) < 2) {
				show_message("名称太短！");
			} else {
				room_goto(rm_connect);
			}
		}
	}
}

draw_set_color(#AAAAAA);
draw_rectangle(left, top, right, bottom, false);

draw_set_font(fontRegular);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);

draw_text(x, y, "进去睡觉");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

