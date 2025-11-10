extends Node3D

var water_orb = preload("res://objects/orbe_agua.tscn")
@onready var timer := $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_child(water_orb.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.get_child_count() < 2 and timer.time_left > 0 and timer.time_left < 0.1:
		self.add_child(water_orb.instantiate())
	if self.get_child_count() < 2 and timer.time_left == 0:
		timer.start(4)
