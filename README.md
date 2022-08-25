# WheatCloudSleep

Wheat Cloud Sleep software, which is meaningless. All you need to do is just open the software and lie down to sleep.

小麦云睡觉软件，很无意义的那种，你需要做的就是打开软件，然后躺下来睡觉。

Server(C++) Source Path: 服务端(C++)源代码路径： ./Source/Server/CloudSleepServer/

Client(GameMaker) Source Path: 客户端(GameMaker)源代码路径： ./Source/CloudSleep/

## 那么我该如何进入官方寝室睡觉呢？

我会在该程序完工后在我的B站上放出视频和可执行文件的下载链接

I will publish executable files on my bilibili after I finish this program

我的B站账户：https://space.bilibili.com/317062050

My Bilibili Account: https://space.bilibili.com/317062050

## 进入寝室后如何睡觉？

鼠标左键 - 拖动视角 | Mouse Left Button - Move Camera

鼠标右键 - 移动 或 睡觉 或 起床 | Mouse Right Button - Move Or Sleep Or Getup

鼠标滚轮 - 缩放 | Mouse Wheel - Zoom

Space键 - 视角跟随睡客 | Space Key - Camera Follow Sleeper

Enter键 - 聊天 | Enter - Chat

## 关于文本输入框

文本输入框使用的是 bilibili UP主 星竍 的代码，这里是BV号：BV1qP4y1s7jt，我使用的是仅单行版本

文本输入框的仅单行版本原版代码里面有个BUG（我不知道别的版本有没有），那就是当镜头的位置不是(0, 0)的时候，虽然文本输入框绘制的位置依然在镜头上，但是判定没有跟随上，还在原来的位置

当然这个BUG可能是因为我用的方式不对，因为好像看星竍他本人的视频里就从没出现过这种情况，额……也不知道为啥，算了不管了

这里我是在 名为 textbox 的 Object 里的 Step事件，修改的前两行，有兴趣可以看一下，注意此处的 GetPositionXOnGUI() 和 GetPositionYOnGUI() 是我自己写的函数，非GameMaker内置，同时如果你要用这两个函数的话要注意一下这两个函数是和镜头绑定的，请确保镜头开启
