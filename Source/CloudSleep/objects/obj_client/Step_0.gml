if(sendMessageQueue.size() > 0 && mySleeperId != -1) {
	SendMessage(sendMessageQueue.Container[0]);
	for(var i = 0; i < sendMessageQueue.size() - 1; i++) {
		sendMessageQueue.Container[i] = sendMessageQueue.Container[i + 1];
	}
	sendMessageQueue.pop_back();
}

if(mouse_check_button_pressed(mb_right)) {
	if(sleepers[mySleeperId].MyPathCanGo(mouse_x, mouse_y)) {
		SendPos(sleepers[mySleeperId].x, sleepers[mySleeperId].y);
		SendMove(mouse_x, mouse_y);
	}
}

if(keyboard_check_pressed(vk_enter)) {
	if(myTextBox == noone) {
		var _placeHolder = textboxPlaceHolders[irandom_range(0, array_length(textboxPlaceHolders) - 1)];
		myTextBox = textbox_create(12, 720 - 48, 950, 28, "", _placeHolder, 128, fontRegular, function() {});
		textbox_set_font(myTextBox, fontRegular, c_black, 28, 0);
		
		myTextBox.curt.fo = true;
		
		if(instance_exists(obj_camera)) {
			obj_camera.mouseCameraMoveLock = true;
		}
	} else {
		SendChat(textbox_return(myTextBox));
		
		instance_destroy(myTextBox);
		myTextBox = noone;
		if(instance_exists(obj_camera)) {
			obj_camera.mouseCameraMoveLock = false;
		}
	}
}

