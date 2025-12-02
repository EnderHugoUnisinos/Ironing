extends Node3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.water_meter.value += 40
		self.queue_free()
