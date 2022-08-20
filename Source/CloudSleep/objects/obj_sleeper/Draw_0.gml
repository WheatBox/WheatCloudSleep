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

draw_sprite(sprite, 0, x, y);

