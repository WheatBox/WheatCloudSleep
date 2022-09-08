#macro while_ until !

randomize();

function DrawTextSetLU() {
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

function DrawTextSetMid() {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
}

function DrawChat(_x, _y, _chatText) {
	draw_set_color(c_black);
	draw_set_font(fontRegular);
	
	var baseWidth = 58;
	
	draw_sprite_ext(spr_ChatBackground, 0, _x, _y + 2, (string_width(_chatText) + baseWidth) / sprite_get_width(spr_ChatBackground), 1, 0, c_white, 0.8);
	draw_set_alpha(0.8);
	draw_sprite(spr_ChatBackgroundTail, 0, _x, _y + 2);
	
	draw_set_alpha(1.0);
	
	DrawTextSetMid();
	draw_text(_x, _y, _chatText);
	DrawTextSetLU();
	
	draw_set_color(c_white);
}

function IsNight() {
	static nightBeginHour = 22, nightBeginMinute = 30;
	static nightEndHour = 6;
	
	// show_debug_message([current_hour, current_minute]);
	
	if((current_hour > nightBeginHour || (current_hour == nightBeginHour && current_minute >= nightBeginMinute)) || current_hour <= nightEndHour) {
		return true;
	}
	
	return false;
}

