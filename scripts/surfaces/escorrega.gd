extends Surface

func surface_iron(player : CharacterBody3D):
	player.current_speed = player.ironing_speed * 0.3
	if player.is_on_floor():
		player.floor_max_angle = deg_to_rad(10)
		
func surface_jump(player):
	player.current_jump_height = player.current_jump_height * 0.3
