working = false;

arrEmoteSprites = [];

if(array_length(gArrSleeperEmoteSprites) > myType)
	if(is_array(gArrSleeperEmoteSprites[myType]))
		arrEmoteSprites = gArrSleeperEmoteSprites[myType];

arrEmoteSpritesLen = array_length(arrEmoteSprites);

blocksInOnePage = 12;

blockAreaDir = 360 / blocksInOnePage;

pointDirection = 0;
pointBlockIndex = 0;

x = 360;
y = 360;
radius = 192;

spriteOffsetX = sprite_get_xoffset(gSleepersSpritesStruct.sprites[myType]);
spriteOffsetY = sprite_get_yoffset(gSleepersSpritesStruct.sprites[myType]);
spriteWidth = sprite_get_width(gSleepersSpritesStruct.sprites[myType]);
spriteHeight = sprite_get_height(gSleepersSpritesStruct.sprites[myType]);


MyEmoteIdStandard = function(_emoteId) {
	while(_emoteId >= arrEmoteSpritesLen) {
		_emoteId -= arrEmoteSpritesLen;
	}
	while(_emoteId < 0) {
		_emoteId += arrEmoteSpritesLen;
	}
	return _emoteId;
}


mySlidingRodIns = GuiElement_CreateSlidingRod(
	0, 0
	, "表情轮盘单页展示数量"
	, 256
	, make_wheat_ptr(EWheatPtrType.Ins, id, "blocksInOnePage")
	, 4, 16
	, function(n) { return round(n); }
);

