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


var _slidingRodSleepersLabelAlphaWidth = 228;
slidingRodSleepersLabelAlphaIns = GuiElement_CreateSlidingRod(
	GuiWidth() - _slidingRodSleepersLabelAlphaWidth
	, (48 + 1) * 0
	, "睡客名称标签透明度"
	, _slidingRodSleepersLabelAlphaWidth
	, make_wheat_ptr(EWheatPtrType.Global, 0, "gSleepersLabelAlpha")
	, 0, 1
	, function(n) { n *= 10; return round(n) / 10; }
);

var _slidingRodSleepersLabelScaleWidth = _slidingRodSleepersLabelAlphaWidth;
slidingRodSleepersLabelScaleIns = GuiElement_CreateSlidingRod(
	GuiWidth() - _slidingRodSleepersLabelScaleWidth
	, (48 + 1) * 0
	, "睡客名称标签大小"
	, _slidingRodSleepersLabelScaleWidth
	, make_wheat_ptr(EWheatPtrType.Global, 0, "gSleepersLabelScale")
	, 0, 2
	, function(n) { n *= 100; return round(n) / 100; }
);

var _slidingRodSleepersChatScaleWidth = _slidingRodSleepersLabelAlphaWidth;
slidingRodSleepersChatScaleIns = GuiElement_CreateSlidingRod(
	GuiWidth() - _slidingRodSleepersChatScaleWidth
	, (48 + 1) * 0
	, "睡客聊天气泡大小"
	, _slidingRodSleepersChatScaleWidth
	, make_wheat_ptr(EWheatPtrType.Global, 0, "gSleepersChatScale")
	, 0, 2
	, function(n) { n *= 100; return round(n) / 100; }
);


var _slidingRodOutFocusLayerAlphaWidth = _slidingRodSleepersLabelAlphaWidth;
slidingRodOutFocusLayerAlphaIns = GuiElement_CreateSlidingRod(
	GuiWidth() - _slidingRodOutFocusLayerAlphaWidth
	, (48 + 1) * 1
	, "睡客重叠物体透明度"
	, _slidingRodOutFocusLayerAlphaWidth
	, make_wheat_ptr(EWheatPtrType.Global, 0, "gDecoratesOverlappingSleeperAlpha")
	, 0, 1
	, function(n) { n *= 10; return round(n) / 10; }
);


var _slidingRodShowSleeperIdWidth = 96;
slidingRodShowSleeperIdIns = GuiElement_CreateSlidingRod(
	0
	, 32
	, "显示睡客ID"
	, _slidingRodShowSleeperIdWidth
	, make_wheat_ptr(EWheatPtrType.Global, 0, "gShowSleeperId")
	, 0, 1
	, function(n) { return round(n); }
);

var _slidingRodHideVoteKickWidth = _slidingRodShowSleeperIdWidth;
slidingRodHideVoteKickIns = GuiElement_CreateSlidingRod(
	0
	, 32
	, "隐藏投票框"
	, _slidingRodHideVoteKickWidth
	, make_wheat_ptr(EWheatPtrType.Global, 0, "gHideVoteKick")
	, 0, 1
	, function(n) { return round(n); }
);

var _slidingRodAutoDayNightWidth = _slidingRodShowSleeperIdWidth;
slidingRodAutoDayNightIns = GuiElement_CreateSlidingRod(
	0
	, 32
	, "自动昼夜循环"
	, _slidingRodHideVoteKickWidth
	, make_wheat_ptr(EWheatPtrType.Global, 0, "gAutoDayNight")
	, 0, 1
	, function(n) { return round(n); }
);

var _slidingRodDayTimeWidth = 512;
slidingRodDayTimeIns = GuiElement_CreateSlidingRod_Time(
	0
	, 32 + 48 + 1
	, "昼夜时间"
	, _slidingRodDayTimeWidth
	, make_wheat_ptr(EWheatPtrType.Ins, obj_day_and_night, "daytime")
	, 0, 24
	, function(n) { gAutoDayNight = false; n *= 100; return round(n) / 100; }
);

