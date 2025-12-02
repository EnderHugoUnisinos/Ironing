extends Control

var menu_open: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("reset"):
		get_tree().current_scene.reload_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu") and get_tree().current_scene.starting_cutscene_played and !get_tree().current_scene.ending_level:
		if !menu_open:
			open_menu()
		else:
			close_menu()

func open_menu():
	menu_open = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	self.visible = true
func close_menu():
	menu_open = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.visible = false
