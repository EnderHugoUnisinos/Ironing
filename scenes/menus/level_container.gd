class_name LevelContainer

extends Control

signal level_choice_return


func _on_return_button_pressed() -> void:
	level_choice_return.emit()
	set_process(false)
