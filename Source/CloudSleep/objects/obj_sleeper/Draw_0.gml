SynchDepth();
/*
var sprite = spr_Boy;

switch(type) {
	case SleeperType.Girl:
		sprite = spr_Girl;
		break;
	case SleeperType.Boy:
		sprite = spr_Boy;
		break;
}*/

var sprite = gSleepersSpritesStruct.sprites[type];

var xscale = 1 + cos(degtorad(timeI)) / 20;
var yscale = 1 + sin(degtorad(timeI)) / 20;

if(emoteIndex != -1) {
	emoteTime++;
	if(emoteTime > emoteTimeMax) {
		emoteIndex = -1;
	} else {
		var _emoteAnimationTimeOffsetHalf = emoteAnimationTimeOffset / 2;
		if(emoteTime <= emoteAnimationTimeOffset) {
			xscale *= 1.0 - 0.1 * (1 - abs(emoteTime - _emoteAnimationTimeOffsetHalf) / _emoteAnimationTimeOffsetHalf);
			yscale *= 1.0 + 0.08 * (1 - abs(emoteTime - _emoteAnimationTimeOffsetHalf) / _emoteAnimationTimeOffsetHalf);
		} else
		if(emoteTime >= emoteTimeMax - emoteAnimationTimeOffset) {
			xscale *= 1.0 + 0.08 * (1 - abs(emoteTimeMax - emoteTime - _emoteAnimationTimeOffsetHalf) / _emoteAnimationTimeOffsetHalf);
			yscale *= 1.0 - 0.1 * (1 - abs(emoteTimeMax - emoteTime - _emoteAnimationTimeOffsetHalf) / _emoteAnimationTimeOffsetHalf);
		}
		
		if(emoteTime >= _emoteAnimationTimeOffsetHalf - 1 && emoteTime <= emoteTimeMax - _emoteAnimationTimeOffsetHalf) {
			sprite = gArrSleeperEmoteSprites[type][emoteIndex];
		}
	}
}

draw_set_alpha(1);
draw_set_color(c_white);

if(isMe && MyPathIsRunning()) {
	draw_path(myPath, 0, 0, true);
}

var angle = radtodeg(((anglePositive > 0) ? cos(degtorad(timeI)) : sin(degtorad(timeI))) / 20);
var angleTemp = radtodeg(sin(degtorad(moveTimeI * 10))) / 6;

if(MyPathIsRunning()) {
	angle = angleTemp;
	
	moveTimeI += anglePositive;
} else {
	moveTimeI = 0;
}

timeI += anglePositive;

if(sleepingBedId == -1) {
	draw_sprite_ext(sprite, 0, x, y, xscale, yscale, angle, c_white, 1);
}

mask_index = sprite;

