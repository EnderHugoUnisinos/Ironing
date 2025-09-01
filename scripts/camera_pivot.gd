extends Node3D  # This script goes on the Pivot node

@onready var player = $".."
@onready var camera = $Camera3D
@export var mouse_sensitivity := 0.3
@export var gamepad_sensitivity := 2.0
@export var gamepad_deadzone := 0.15

var gamepad_rotation := 0.0

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * mouse_sensitivity))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
		# Handle gamepad look
	self.global_position = player.global_position
	var gamepad_input = Input.get_axis("look_left", "look_right")
	
	# Apply deadzone to prevent drift
	if abs(gamepad_input) > gamepad_deadzone:
		gamepad_rotation = -gamepad_input * gamepad_sensitivity * delta
		rotate_y(gamepad_rotation)
	self.global_rotation.z = 0
