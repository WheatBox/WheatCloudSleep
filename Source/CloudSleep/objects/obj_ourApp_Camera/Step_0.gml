OurAppStepEventHead

MyCheckAndRemakeMycamsurf();

if(surface_exists(mycamsurf)) {
	draw_set_alpha(1.0);
	draw_set_color(c_white);
	
	var _surfTargetTemp = surface_get_target();
	if(_surfTargetTemp != -1) {
		surface_reset_target();
	}
	surface_set_target(mycamsurf);
	
	if(surface_exists(application_surface) && instance_exists(obj_day_and_night)) {
		shader_set(obj_day_and_night.shader);
		shader_set_uniform_f_array(obj_day_and_night.u_col, obj_day_and_night.color_mix);
		shader_set_uniform_f_array(obj_day_and_night.u_con_sat_brt, obj_day_and_night.con_sat_brt_mix);
		texture_set_stage(obj_day_and_night.s_lights, obj_day_and_night.tex_lights);
	
		draw_clear(c_black);
	
		//var _mycamx = gOurPhoneX + OurPhoneScreenWidth / 2;
		//var _mycamy = gOurPhoneY + -16;
		//draw_surface_part(
		//	application_surface
		//	, _mycamx - OurPhoneScreenWidth / 2, _mycamy - OurPhoneScreenHeight / 2
		//	, _mycamx + OurPhoneScreenWidth / 2, _mycamy + OurPhoneScreenHeight / 2
		//	, 0, 0
		//);
	
		draw_surface_part(application_surface, gOurPhoneX, gOurPhoneY, gOurPhoneX + OurPhoneScreenWidth, gOurPhoneY + OurPhoneScreenHeight, 0, 0);
	
		shader_reset();
	}

	surface_reset_target();
	if(_surfTargetTemp != -1) {
		surface_set_target(_surfTargetTemp);
	}
	
	
	draw_clear(c_black);
	draw_surface(mycamsurf, 0, 0);
	
	
	if(myshotWhiteAlpha > 0.05) {
		myshotWhiteAlpha = lerp(myshotWhiteAlpha, 0, 0.2);
	} else {
		myshotWhiteAlpha = 0;
	}
	
	draw_set_alpha(myshotWhiteAlpha);
	
	draw_rectangle(0, 0, OurPhoneScreenWidth, OurPhoneScreenHeight, false);
	
	
	draw_set_alpha(1.0);
	
	var _shotButtonX = OurPhoneScreenWidth / 2;
	var _shotButtonY = OurPhoneScreenHeight - 40;
	
	if(point_in_circle(gMouseOnOurPhoneX, gMouseOnOurPhoneY, _shotButtonX, _shotButtonY, myshotButtonRadius)) {
		myshotButtonRadius = lerp(myshotButtonRadius, myshotButtonRadiusEnd, 0.2);
		
		GUI_SetCursorHandpoint();
		
		if(MouseLeftPressed()) {
			MyShot();
		}
	} else {
		myshotButtonRadius = lerp(myshotButtonRadius, myshotButtonRadiusStart, 0.2);
	}
	
	draw_circle(_shotButtonX, _shotButtonY, myshotButtonRadius, false);
	draw_circle(_shotButtonX, _shotButtonY, myshotButtonRadius + 4, true);
}

OurAppStepEventTail
