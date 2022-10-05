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

slidingRodOutFocusLayerAlphaIns = GuiElement_CreateSlidingRod(
	GuiWidth() - slidingRodOutFocusLayerAlphaWidth
	, (48 + 1) * 0
	, "睡客重叠物体透明度"
	, slidingRodOutFocusLayerAlphaWidth
	, 0, 0
	, "gDecoratesOverlappingSleeperAlpha"
	, 0, 1
	, function(n) { n *= 10; return round(n) / 10; }
);

slidingRodSleepersLabelAlphaIns = GuiElement_CreateSlidingRod(
	GuiWidth() - slidingRodSleepersLabelAlphaWidth
	, (48 + 1) * 1
	, "睡客名称标签透明度"
	, slidingRodSleepersLabelAlphaWidth
	, 0, 0
	, "gSleepersLabelAlpha"
	, 0, 1
	, function(n) { n *= 10; return round(n) / 10; }
);

