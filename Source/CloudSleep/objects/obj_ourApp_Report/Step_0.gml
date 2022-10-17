OurAppStepEventHead

draw_set_color(#BBBBBB);
draw_set_alpha(1);

GUI_DrawRectangle(0, 0, OurPhoneScreenWidth, titleHeight);

draw_set_color(#DDDDDD);

GUI_DrawRectangle(0, titleHeight + 1, OurPhoneScreenWidth, OurPhoneScreenHeight);

draw_set_color(c_black);
draw_text(4, 2, "举报不良睡客或违规消息");

draw_line_width_color(0, titleHeight, OurPhoneScreenWidth, titleHeight, 2, c_black, c_black);

mySleeperIdTextbox.WorkEasy();
myReasonTextbox.WorkEasy();


if(OurPhoneGUI_MouseGuiOnMe(0, OurPhoneScreenHeight - 32 + 1, OurPhoneScreenWidth, OurPhoneScreenHeight)) {
	GUI_SetCursorHandpoint();
	draw_set_color(#CCCCCC);
	
	if(MouseLeftPressed()) {
		if(myReasonTextbox.GetContent() == "") {
			show_message_async("举报内容不能为空！！");
		} else {
			// 发送举报消息
			SendReport(
				string(mySleeperIdTextbox.GetContent())
				+ "|"
				+ string(myReasonTextbox.GetContent())
			);
			
			mySleeperIdTextbox.ClearContent();
			myReasonTextbox.ClearContent();
		}
	}
} else {
	draw_set_color(#888888);
}

GUI_DrawRectangle(0, OurPhoneScreenHeight - 32 + 1, OurPhoneScreenWidth, OurPhoneScreenHeight);

draw_set_color(c_black);
GUI_DrawText(OurPhoneScreenWidth / 2, OurPhoneScreenHeight - 16 - 4, "点我发送举报信息", true);


OurAppStepEventTail
