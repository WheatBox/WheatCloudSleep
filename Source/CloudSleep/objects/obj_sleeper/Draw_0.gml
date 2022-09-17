depth = -y;
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

draw_set_alpha(1);

if(isMe && MyPathIsRunning()) {
	draw_path(myPath, 0, 0, true);
}

var xscale = 1 + cos(degtorad(timeI)) / 20;
var yscale = 1 + sin(degtorad(timeI)) / 20;

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

