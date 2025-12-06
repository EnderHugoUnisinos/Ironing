extends Control

@onready var level_name_label : Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/level_name 
@onready var level_time_label : Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/level_time 
@onready var water_level_label : Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/water_level 

enum Scene {MENU, GARAGEM, SALA, TUTORIAL}

func end_level(level_time):
	match get_tree().current_scene.current_scene:
		Scene.GARAGEM:
			level_name_label.text = "GARAGEM"
		Scene.SALA:
			level_name_label.text = "SALA DE ESTAR"
		Scene.TUTORIAL:
			level_name_label.text = "TUTORIAL"
	level_time_label.text = level_time
	water_level_label.text = get_tree().current_scene.water_level
	
func _on_again_pressed() -> void:
	get_tree().current_scene.reload_scene()

func _on_menu_pressed() -> void:
	get_tree().current_scene.load_main_menu()

func _on_next_pressed() -> void:
	match get_tree().current_scene.current_scene:
		Scene.TUTORIAL:
			get_tree().current_scene.load_level_0()
		Scene.GARAGEM:
			get_tree().current_scene.load_level_1()
		Scene.SALA:
			get_tree().current_scene.load_main_menu()
