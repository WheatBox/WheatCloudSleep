depth = -y;

var sprite = spr_Boy;

switch(type) {
	case SleeperType.Girl:
		sprite = spr_Girl;
		break;
	case SleeperType.Boy:
		sprite = spr_Boy;
		break;
}

draw_set_alpha(1);

if(isMe && MyPathIsRunning()) {
	draw_path(myPath, 0, 0, true);
}

var xscale = 1;
var yscale = 1;
draw_sprite_ext(sprite, 0, x, y, xscale, yscale, 0, c_white, 1);

