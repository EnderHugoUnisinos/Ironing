extends Area3D
@export_enum("GARAGEM","SALA","MENU") var next_level : int

func end_level_screen():
	get_tree().current_scene.end_level()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		end_level_screen()
