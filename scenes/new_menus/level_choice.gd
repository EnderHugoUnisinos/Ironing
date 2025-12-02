class_name LevelChoice

extends Control

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_menu") and self.visible == true:
		self.visible = false

func _on_button_pressed() -> void:
	get_tree().current_scene.load_level_0()
	#get_tree().change_scene_to_file("res://scenes/nivel/nivel_garagem.tscn")


func _on_button_2_pressed() -> void:
	get_tree().current_scene.load_level_1()
	#get_tree().change_scene_to_file("res://scenes/nivel/nivel_sala_de_estar.tscn")
