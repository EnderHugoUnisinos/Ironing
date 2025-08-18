extends Node3D  # This script goes on the Pivot node

@export var rotation_speed := 0.1 
#@export var max_v_angle = 20
#@export var min_v_angle = 50
@onready var camera = $Camera3D

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * rotation_speed))
		#rotate_x(-deg_to_rad(event.relative.y * rotation_speed))
		#self.rotation.x = clamp(self.rotation.x, -deg_to_rad(min_v_angle), deg_to_rad(max_v_angle))
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	self.global_rotation.z = 0
