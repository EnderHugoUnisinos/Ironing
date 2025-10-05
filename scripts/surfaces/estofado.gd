extends Surface

func surface_iron(player):
	player.current_speed = player.ironing_speed * 0.8
	if player.is_on_floor():
		player.water_meter.value -= 0.2


func surface_jump(player):
	player.current_jump_height = player.current_jump_height * 1.4
