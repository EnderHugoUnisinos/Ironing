extends Label

var time_elapsed := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	var minutes := time_elapsed / 60
	var seconds := fmod(time_elapsed, 60)
	var milliseconds := fmod(time_elapsed, 1) * 100
	self.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
