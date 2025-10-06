extends Control


@onready var audio_label: Label = $HBoxContainer/Audio_Label as Label
@onready var value_label: Label = $HBoxContainer/Value_Label as Label
@onready var h_slider: HSlider = $HBoxContainer/HSlider as HSlider


@export_enum("Master", "Music", "SFX") var bus_name : String

var bus_index : int = 0


func _ready() -> void:
	get_bus_name_by_index()
	load_data()
	set_audio_label_text()
	set_slider_value()


func load_data() -> void:
	match bus_index:
		0:
			_on_h_slider_value_changed(SettingsData.get_master_volume())
		1:
			_on_h_slider_value_changed(SettingsData.get_music_volume())
		2: 
			_on_h_slider_value_changed(SettingsData.get_sfx_volume())

func set_audio_label_text() -> void:
	audio_label.text = str(bus_name)


func set_value_label_text() -> void:
	value_label.text = str(h_slider.value * 100)


func get_bus_name_by_index() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)


func set_slider_value() -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_value_label_text()

func _on_h_slider_value_changed(value: float) -> void:
	match bus_index:
		0: 
			SettingsSignals.emit_master_sound(value)
		1:
			SettingsSignals.emit_music_sound(value)
		2: 
			SettingsSignals.emit_sfx_sound(value)
		
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_value_label_text()
