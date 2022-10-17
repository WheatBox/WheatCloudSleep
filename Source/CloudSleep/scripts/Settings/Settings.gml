// 当前客户端版本
#macro ClientVersion "WheatCloudSleep_v1.0.0"

// 关于该客户端的信息
#macro ClientAbout (\
	"云睡觉官方版本v1.0.0\n" + \
	"服务端开发：\n" + \
	"\t" + "github@ymx-mshk\n" + \
	"\t" + "github@B1aNB1aN\n" + \
	"\t" + "github@zhhhhhhhh\n" + \
	"\t" + "github@WheatBox\n" + \
	"客户端开发：\n" + \
	"\t" + "github@WheatBox\n" + \
	"美术创作：\n" + \
	"\t" + "github@WheatBox\n"\
)

// 聊天记录的接收范围的圆的半径，单位：像素
#macro ChatHistoryRecordMaxDistance 3200

// 聊天记录的最大记录条数
#macro ChatHistoryMaxLines 100

// 名称的最短长度
#macro NameMinimumLength 2

// GUI滚动速度
#macro GUIScrollYSpeed 50



// 非程序可执行目录的保存位置
// 请尽量不要更改这一小段，除非你希望用户在从别的客户端切换到你开发的客户端的时候需要把配置项再都部署一遍
if(file_exists("settings.ini") == false) {
	file_text_close(file_text_open_write("settings.ini"));
}
globalvar __SavePath;
__SavePath = filename_dir("settings.ini") + "\\";
#macro SavePath __SavePath

// 外部配置项文件
#macro FILEINI_Settings (SavePath + "settings.ini")
/*
[user]
name = myName
[ourPhone]
wallpaperFilename = "xxxxx.png"
musicDir = "X:\xxxx\"
musicLoopMode = 0
*/


globalvar gDecoratesOverlappingSleeperAlpha;
gDecoratesOverlappingSleeperAlpha = 0.9;
globalvar gSleepersLabelAlpha, gSleepersLabelScale, gSleepersChatScale;
gSleepersLabelAlpha = 0.7;
gSleepersLabelScale = 1.0;
gSleepersChatScale = 1.0;
globalvar gHideVoteKick;
gHideVoteKick = 0;


#macro OtherSleepersChatHistoryMaxLen 10


#macro DEBUGMODE 0
show_debug_overlay(DEBUGMODE);
