var str = "投票踢出 @" + name;

var _x = GetPositionXOnGUI(x);
var _y = GetPositionYOnGUI(y);

var strW = string_width(str);
var strH = string_height(str);

draw_set_color(c_red);
draw_set_alpha(0.5);
draw_rectangle(_x - strW / 2, _y - strH / 2, _x + strW / 2, _y + strH / 2, false);

draw_set_color(c_white);
draw_rectangle(_x - strW / 2, _y - strH / 2, _x - strW / 2 + strW * (voteLoading / voteLoadingMax), _y + strH / 2, false);


draw_set_alpha(1);
DrawTextSetMid();
draw_text(_x, _y, str);
DrawTextSetLU();
