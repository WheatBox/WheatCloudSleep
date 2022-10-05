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

var _slidingRodOutFocusLayerAlphaWidth = 228;
slidingRodOutFocusLayerAlphaIns = GuiElement_CreateSlidingRod(
	GuiWidth() - _slidingRodOutFocusLayerAlphaWidth
	, (48 + 1) * 0
	, "睡客重叠物体透明度"
	, _slidingRodOutFocusLayerAlphaWidth
	, 0, 0
	, "gDecoratesOverlappingSleeperAlpha"
	, 0, 1
	, function(n) { n *= 10; return round(n) / 10; }
);

var _slidingRodSleepersLabelAlphaWidth = _slidingRodOutFocusLayerAlphaWidth;
slidingRodSleepersLabelAlphaIns = GuiElement_CreateSlidingRod(
	GuiWidth() - _slidingRodSleepersLabelAlphaWidth
	, (48 + 1) * 1
	, "睡客名称标签透明度"
	, _slidingRodSleepersLabelAlphaWidth
	, 0, 0
	, "gSleepersLabelAlpha"
	, 0, 1
	, function(n) { n *= 10; return round(n) / 10; }
);

var _slidingRodShowSleeperIdWidth = 96;
slidingRodShowSleeperIdIns = GuiElement_CreateSlidingRod(
	GuiWidth() - _slidingRodShowSleeperIdWidth
	, (48 + 1) * 2
	, "显示睡客ID"
	, _slidingRodShowSleeperIdWidth
	, 0, 0
	, "gShowSleeperId"
	, 0, 1
	, function(n) { return round(n); }
);

