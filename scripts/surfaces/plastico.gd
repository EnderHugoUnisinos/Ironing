extends Surface

func surface_iron(player):
	player.floor_max_angle = deg_to_rad(50)
	player.current_speed = player.ironing_speed * 0.96
	if player.is_on_floor():
		player.water_meter.value -= 0.2

func surface_jump(player):
	player.current_jump_height = player.current_jump_height * 0.9
	
