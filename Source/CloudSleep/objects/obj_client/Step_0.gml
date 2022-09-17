if(sendMessageQueue.size() > 0 && mySleeperId != -1) {
	SendMessage(sendMessageQueue.Container[0]);
	for(var i = 0; i < sendMessageQueue.size() - 1; i++) {
		sendMessageQueue.Container[i] = sendMessageQueue.Container[i + 1];
	}
	sendMessageQueue.pop_back();
}

if(mouse_check_button_pressed(mb_right)) {
	if(instance_exists(sleepers[mySleeperId])) {
		if(sleepers[mySleeperId].sleepingBedId == -1) {
			if(sleepers[mySleeperId].MyPathCanGo(mouse_x, mouse_y)) {
				SendPos(sleepers[mySleeperId].x, sleepers[mySleeperId].y);
				SendMove(mouse_x, mouse_y);
				
				sleepers[mySleeperId].willSleep = false;
			} else {
				var _dir = point_direction(sleepers[mySleeperId].x, sleepers[mySleeperId].y, mouse_x, mouse_y);
				var _len1x = lengthdir_x(1, _dir);
				var _len1y = lengthdir_y(1, _dir);
				
				var _collibackdis = 1;
				var _bedIns = collision_point(mouse_x, mouse_y, obj_bed, true, false);
				if(InstanceExists(_bedIns))
				if(sprite_exists(_bedIns.sprite_index)) {
					_collibackdis = sqrt(power(_bedIns.sprite_width, 2) + power(_bedIns.sprite_height, 2)) + 1;
				}
				
				for(var ixy = 0; ixy < _collibackdis; ixy++) {
					var _x = mouse_x - round(_len1x * ixy);
					var _y = mouse_y - round(_len1y * ixy);
					if(sleepers[mySleeperId].MyPathCanGo(_x, _y)) {
						SendPos(sleepers[mySleeperId].x, sleepers[mySleeperId].y);
						SendMove(_x, _y);
						
						sleepers[mySleeperId].willSleep = true;
						
						break;
					}
				}
			}
		} else {
			SendGetup();
		}
	}
}

if(keyboard_check_pressed(vk_enter)) {
	chatHistoryScrollY = 0;
	
	if(myTextBox == noone) {
		var _placeHolder = textboxPlaceHolders[irandom_range(0, array_length(textboxPlaceHolders) - 1)];
		myTextBox = textbox_create(12, GuiHeight() - 48, 950, 28, "", _placeHolder, 128, fontRegular, function() {});
		textbox_set_font(myTextBox, fontRegular, c_black, 28, 0);
		
		myTextBox.curt.fo = true;
		/*
		if(instance_exists(obj_camera)) {
			obj_camera.mouseCameraMoveLock = true;
		}*/
	} else {
		var sendStr = textbox_return(myTextBox);
		if(sendStr != "") {
			SendChat(sendStr);
		}
		
		instance_destroy(myTextBox);
		myTextBox = noone;
		/*if(instance_exists(obj_camera)) {
			obj_camera.mouseCameraMoveLock = false;
		}*/
	}
}

if(keyboard_check_pressed(vk_escape)) {
	instance_destroy(myTextBox);
	myTextBox = noone;
}

if(myTextBox != noone) {
	textbox_set_position(myTextBox, 12, GuiHeight() - 48, false);
	
	if(GUI_MouseGuiOnMe(12, GuiHeight() - 48, 12 + 950, GuiHeight() - 48 + 28)) {
		gMouseOnGUI = true;
	}
}

