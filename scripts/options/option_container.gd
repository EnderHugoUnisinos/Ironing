class_name OptionsContainer
extends Control

signal options_menu_return

func _on_return_button_pressed() -> void:
	options_menu_return.emit()
	set_process(false)
