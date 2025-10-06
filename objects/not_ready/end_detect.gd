extends Node

@export var catbed : Node3D
@export var glow_mesh : MeshInstance3D
@onready var animation_player : AnimationPlayer = $"indicator-round-a2/AnimationPlayer"

var player_inside: bool = false

signal next_level

var status : bool = false :
	set(value):
		status = value

func _ready() -> void:
	update_next_pass()
	catbed.changed.connect(_status_changed)

func _status_changed(value):
	status = value
	update_next_pass()
	animation_player.play("animation")
	if player_inside:
			next_level.emit()
		
func update_next_pass():
	glow_mesh.get_surface_override_material(0).set_shader_parameter("is_highlighted", status)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		if status:
			next_level.emit()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = false
