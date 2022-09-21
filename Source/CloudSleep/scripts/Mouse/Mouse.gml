function MouseLeftPressed() {
	return mouse_check_button_pressed(mb_left);
}

function MouseRightPressed() {
	return mouse_check_button_pressed(mb_right);
}


function MouseLeftHold() {
	return mouse_check_button(mb_left);
}

function MouseMidHold() {
	return mouse_check_button(mb_middle);
}

function MouseRightHold() {
	return mouse_check_button(mb_right);
}


function MouseLeftReleased() {
	return mouse_check_button_released(mb_left);
}

function MouseRightReleased() {
	return mouse_check_button_released(mb_right);
}

