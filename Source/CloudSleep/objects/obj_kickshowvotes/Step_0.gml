if(!OnVote) {
	instance_destroy();
	exit;
}

if(gHideVoteKick) {
	exit;
}

if(keyboard_check_pressed(vk_f1)) {
	SendAgree();
} else if(keyboard_check_pressed(vk_f2)) {
	SendRefuse();
}

