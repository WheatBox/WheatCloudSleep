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

function CreateKickShowVotes(whoVoteSleeperId, kickSleeperId) {
	if(!OnVote) {
		return;
	}
	if(instance_exists(obj_client) == false) {
		return;
	}
	if(obj_client.MyCanUseSleeperId(whoVoteSleeperId) == false) {
		return;
	}
	if(obj_client.MyCanUseSleeperId(kickSleeperId) == false) {
		return;
	}
	
	var ins = instance_create_depth(0, 0, -10000, obj_kickShowVotes);
	ins.sleeperId = kickSleeperId;
	ins.whoVoteName = obj_client.sleepers[whoVoteSleeperId].name;
	ins.kickName = obj_client.sleepers[kickSleeperId].name;
	ins.whoVoteSleeperId = whoVoteSleeperId;
	ins.kickSleeperId = kickSleeperId;
}

