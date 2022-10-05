function set_alpha() {
	shader_set(shd_alpha);
	with(obj_day_and_night) shader_set_uniform_f(u_alpha, alpha);
}

function reset_alpha() {
	shader_reset();
}

