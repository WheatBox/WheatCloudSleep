beds = [];

var _initBedSleepId = 0;
for(var iy = 0; iy < 16; iy++) {
	for(var ix = 0; ix < 16; ix++) {
		var _offsetY = 320 + 256;
		var _offsetX = 768 + 128 + (iy % 2 == 0 ? 128 : 0);
		beds[_initBedSleepId] = CreateBed(ix * 320 + _offsetX, iy * 288 + _offsetY, _initBedSleepId);
		_initBedSleepId++;
	}
}

mp_grid_add_instances(grid, obj_bed, false);

sleepers = [];

SendName();
SendType();

synchPosRateTime = 5 * 60; // 五秒向服务器发送一次自己的坐标，让其它客户端进行同步
alarm_set(0, synchPosRateTime);

MyGetSleeperIdMax = function() {
	return array_length(sleepers) - 1;
}

MyCanUseSleeperId = function(sleeperId) {
	var sleeperIdMax = MyGetSleeperIdMax();
	if(sleeperIdMax < sleeperId || sleeperId < 0) {
		return false;
	}
	if(!instance_exists(sleepers[sleeperId])) {
		return false;
	}
	return true;
}

vecChatHistory = new vector(); 
vecChatHistorySizeMax = 15;
chatHistoryOn = false;

MyChatHistoryAdd = function(sleeperId, str) {
	if(MyCanUseSleeperId(sleeperId) == false) {
		return;
	}
	vecChatHistory.push_back("[@" + string(sleepers[sleeperId].name) + "]: " + string(str));
	
	if(vecChatHistory.size() > vecChatHistorySizeMax) {
		array_delete(vecChatHistory.Container, 0, 1);
	}
}

myTextBox = noone;

textboxPlaceHolders = [
	"说点什么吧，我亲爱的" + myName + " (づ￣ 3￣)づ",
	"早上好" + myName + "！或者……晚上好？",
	"今天过得还好么，" + myName + "，如果遇到不顺心的事情就说出来吧",
	myName + "，如果今天还没有人给你夸夸的话，那我来好了~亲爱的，你是最棒的！",
	"如果现在是深夜，" + myName + "，你依然没有睡，那不妨和我们聊聊吧~",
	"我爱你！" + myName + "！！",
	"亲爱的" + myName + "，你知道么，任何挫折都算不上什么，睡一觉就会好，来睡觉吧~",
	"加油，我爱你" + myName + "，*抱*",
	"你真的好温暖，" + myName + "，我要抱抱你（羞涩）",
	"睡觉前说点什么吧，" + myName + "，顺便缓解一下心情",
	myName + "相信我，都会好的，来睡觉吧~",
	"没有什么东西是比睡前聊两句更令人愉快的了，你说对吧？" + myName,
	"睡一觉吧，" + myName + "，然后打起精神来",
	"先睡觉吧，明天一大早，我们一起去码头整点薯条，" + myName,
	"其实你是个天才，" + myName + "，相信我，总有一天你会惊艳世界",
	myName + "，睡前和我们聊聊吧",
	"记得要乖乖睡觉哦~，" + myName + "，我会陪在你身边的",
	"感觉好孤单，但是有你在这里，感觉就好多了，" + myName + "，谢谢你",
	"一起睡觉吧" + myName + "，我爱你，在你所处的那个时空中也要乖乖睡觉哦",
	"晚安，生活，明天我会回来起舞！晚安，" + myName + "，我爱你",
	"好无聊，一起睡觉吧，" + myName,
	"你知道么，我喜欢黑夜，静静的，这是独属于我的时间，但还是要乖乖睡觉才行",
	"我要黑化！呜啊~~~，算了还是睡觉吧",
	"服务端和客户端的源代码都是完全公开的，你可以在我的B站 @小麦盒子 找到相关视频和Github链接",
	"顺带一提我的服务器仅有 1Mbps 的带宽，也就是说理论最高速只有 128kb/s，实际速度就更低了",
];

