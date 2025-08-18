extends Node3D  # This script goes on the Pivot node

@export var rotation_speed := 0.1
@onready var camera = $Camera3D

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * rotation_speed))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	self.global_rotation.z = 0
