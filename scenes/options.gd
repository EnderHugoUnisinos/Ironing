extends Control

func _on_option_container_options_menu_return() -> void:
	self.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_menu") and self.visible == true:
		self.visible = false
