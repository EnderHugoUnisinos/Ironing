extends Node3D

func _process(delta: float) -> void:
	self.rotate_y(0.05)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.water_meter.value += 40
		self.queue_free()
