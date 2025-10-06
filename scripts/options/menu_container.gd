extends Control

@onready var options_container = $Option_Container as OptionsContainer
@onready var main_menu = $Main_Menu as PanelContainer
@onready var panel: Panel = $Panel
@onready var level_container: LevelContainer = $Level_Container


func _on_start_button_pressed() -> void:
	main_menu.visible = false
	panel.visible = false
	level_container.set_process(true)
	level_container.visible = true


func _on_options_button_pressed() -> void:
	main_menu.visible = false
	panel.visible = false
	options_container.set_process(true)
	options_container.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_option_container_options_menu_return() -> void:
	main_menu.visible = true
	options_container.visible = false
	panel.visible = true


func _on_level_container_level_choice_return() -> void:
	main_menu.visible = true
	level_container.visible = false
	panel.visible = true
