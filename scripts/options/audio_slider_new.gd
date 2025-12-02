extends Control

@export_enum("Master", "Music", "SFX") var bus_name : String

var bus_index : int = 0
var label : Label

func _ready() -> void:
	self.value_changed.connect(_on_value_changed)
	var label_name = "%s_Value" % self.name
	label = get_parent().find_child(label_name)
	bus_index = AudioServer.get_bus_index(bus_name)
	self.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	label.text = "%.1f %%" % (self.value * 100)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	label.text = "%.1f %%" % (self.value * 100)
