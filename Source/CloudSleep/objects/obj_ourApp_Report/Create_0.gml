event_inherited();

titleHeight = 32;

mySleeperIdTextbox = new OurPhoneGuiElement_TextBox(4, 36, OurPhoneScreenWidth - 4 - 4, 28, 16, "目标睡客ID或名称（选填）"); 
myReasonTextbox = new OurPhoneGuiElement_TextBox(
	4
	, 36 + 28 + 4
	, OurPhoneScreenWidth - 4 - 4
	, OurPhoneScreenHeight - 36 - 28 - 4 - 4 - 32
	, 128
	, @'举报内容、理由，例如：
	发送不良消息
	使用不良名称
	偷吃了我最爱的草莓蛋糕
	……'
);

