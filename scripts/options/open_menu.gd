extends Control

var current_paused: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("reset"):
		get_parent().get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		current_paused = !current_paused
		get_tree().paused = current_paused
		if current_paused:
			open_menu()
		else:
			close_menu()

func open_menu():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	self.visible = true
func close_menu():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.visible = false
