if(mySleeperId < 0) {
	alarm_set(2, 1);
	exit;
}

buttonOpenOurPhone = GuiElement_CreateButton(buttonOpenOurPhoneX, buttonOpenOurPhoneY, "ourPhone"
	, function() {
		if(InstanceExists(obj_ourPhone)) {
			if(obj_ourPhone.working) {
				obj_ourPhone.MyStopWork();
			} else {
				obj_ourPhone.MyWork();
			}
		}
	}
);

