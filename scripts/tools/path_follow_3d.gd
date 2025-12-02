@tool
extends PathFollow3D

@export var follow : bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow and Engine.is_editor_hint():
		self.progress_ratio += delta * 0.07
