var str = string(whoVoteSleeperId) + "[@" + whoVoteName + "] 发起投票是否踢出 " + string(kickSleeperId) + "[@" + kickName + "]";
str += "\n按下F1 同意踢出，当前同意人数：" + string(agreesNum);
str += "\n按下F2 反对踢出，当前反对人数：" + string(refusesNum);

draw_set_color(#76000C);
draw_set_alpha(0.8);
draw_rectangle(100, 100, 100 + string_width(str), 100 + string_height(str), false);

draw_set_color(c_white);
draw_set_alpha(1);
draw_text(100, 100, str);

