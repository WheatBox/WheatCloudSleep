switch(type) {
	case SleeperType.Girl:
		sprite_index = spr_Girl;
		break;
	case SleeperType.Boy:
		sprite_index = spr_Boy;
		break;
}

if(type == myType) {
	image_xscale = lerp(image_xscale, 1.2, 0.2);
} else if(mouse_x >= bbox_left && mouse_y >= bbox_top && mouse_x <= bbox_right && mouse_y <= bbox_bottom) {
	image_xscale = lerp(image_xscale, 1.2, 0.2);
	if(mouse_check_button_pressed(mb_left)) {
		myType = type;
	}
} else {
	image_xscale = lerp(image_xscale, 1, 0.2);
}
image_yscale = image_xscale;

draw_self();

if(type == myType) {
	draw_set_color(c_white);
	draw_set_alpha(0.4);
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
	draw_set_alpha(1);
}

