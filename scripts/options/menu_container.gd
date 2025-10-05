extends Control

@onready var options_container = $Option_Container as OptionsContainer
@onready var main_menu = $Main_Menu as PanelContainer


func _on_start_button_pressed() -> void:
	self.get_parent().close_menu()


func _on_options_button_pressed() -> void:
	main_menu.visible = false
	options_container.set_process(true)
	options_container.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_option_container_options_menu_return() -> void:
	main_menu.visible = true
	options_container.visible = false
