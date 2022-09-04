draw_set_font(fontRegular);
draw_set_color(c_white);

var strDots = "";
var dotsNum = getDrawDots();
for(var i = 0; i < dotsNum; i++) {
	strDots += ".";
}
draw_text(320, 320, "正在连接服务器" + strDots);

gMouseOnGUI = true;

