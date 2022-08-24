# WheatCloudSleep

Unfinished

未完工

Wheat Cloud Sleep software, which is meaningless. All you need to do is just open the software and lie down to sleep.

小麦云睡觉软件，很无意义的那种，你需要做的就是打开软件，然后躺下来睡觉。

Server(C++) Source Path: 服务端(C++)源代码路径： ./Source/Server/CloudSleepServer/

Client(GameMaker) Source Path: 客户端(GameMaker)源代码路径： ./Source/CloudSleep/

## 关于文本输入框

文本输入框使用的是 bilibili UP主 星竍 的代码，这里是BV号：BV1qP4y1s7jt，我使用的是仅单行版本

文本输入框的仅单行版本原版代码里面有个BUG（我不知道别的版本有没有），那就是当镜头的位置不是(0, 0)的时候，虽然文本输入框绘制的位置依然在镜头上，但是判定没有跟随上，还在原来的位置

当然这个BUG可能是因为我用的方式不对，因为好像看星竍他本人的视频里就从没出现过这种情况，额……也不知道为啥，算了不管了

这里我的修复方法是在 名为 textbox 的 Object 里的 Step事件，将前两行修改为

    var mx = window_mouse_get_x(),
    my = window_mouse_get_y(),
    
就可以了
