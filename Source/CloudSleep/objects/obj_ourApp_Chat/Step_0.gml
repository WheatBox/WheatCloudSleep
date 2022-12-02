OurAppStepEventHead

switch(myScene) {
	case eMyScene.AllSleepers:
	case eMyScene.RecentSleepers:
	case eMyScene.UnReadSleepers:
		MySelectSleepersScene();
		break;
		
	case eMyScene.Chat:
		MyChatScene();
		break;
}

OurAppStepEventTail
