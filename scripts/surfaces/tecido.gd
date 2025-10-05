extends Surface

func surface_iron(player):
	player.current_speed = player.ironing_speed * 1.5
	if player.is_on_floor():
		player.water_meter.value -= 0.1
