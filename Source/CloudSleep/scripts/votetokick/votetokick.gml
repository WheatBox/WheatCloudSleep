globalvar OnVote;
OnVote = false;

function CreateKickWhoBox(sleeperId) {
	if(OnVote) {
		return;
	}
	if(instance_exists(obj_client) == false) {
		return;
	}
	if(obj_client.MyCanUseSleeperId(sleeperId) == false) {
		return;
	}
	
	var ins = instance_create_depth(mouse_x, mouse_y, -10000, obj_kickWhoBox);
	ins.sleeperId = sleeperId;
	ins.name = obj_client.sleepers[sleeperId].name;
}

function CreateKickShowVotes(sleeperId) {
	if(!OnVote) {
		return;
	}
	if(instance_exists(obj_client) == false) {
		return;
	}
	if(obj_client.MyCanUseSleeperId(sleeperId) == false) {
		return;
	}
	
	var ins = instance_create_depth(0, 0, -10000, obj_kickShowVotes);
	ins.sleeperId = sleeperId;
	ins.kickName = obj_client.sleepers[sleeperId].name;
}

