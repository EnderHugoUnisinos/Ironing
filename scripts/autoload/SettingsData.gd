extends Node

@onready var keybind_resource : PlayerKeybindResource = preload("res://scenes/resources/PlayerKeybindDefault.tres")

var window_mode : int = 0
var resolution : int = 0
var master_volume : float = 0
var music_volume: float = 0
var sfx_volume: float = 0

var loaded_data : Dictionary = {}

func _ready():
	handle_signals() 
	create_settings_dictionary()
	

func create_settings_dictionary() -> Dictionary:
	var settings_dict : Dictionary = {
		"window_mode" : window_mode,
		"resolution" : resolution,
		"master_volume" : master_volume,
		"music_volume" : music_volume,
		"sfx_volume" : sfx_volume, 
		"keybinds" : create_keybinds_dictionary()
	}
	
	return settings_dict

func create_keybinds_dictionary() -> Dictionary:
	var keybinds_dict = {
		keybind_resource.FORWARD : keybind_resource.forward_key,
		keybind_resource.BACKWARD : keybind_resource.backward_key,
		keybind_resource.LEFT : keybind_resource.left_key,
		keybind_resource.RIGHT : keybind_resource.right_key,
		keybind_resource.SPECIAL : keybind_resource.special_key,
		keybind_resource.JUMP : keybind_resource.jump_key,
		keybind_resource.RESET : keybind_resource.reset_key
	}
	
	return keybinds_dict

func get_window_mode() -> int:
	if loaded_data == {}:
		return 0
	return window_mode

func get_resolution() -> int:
	if loaded_data == {}:
		return 0
	return resolution

func get_master_volume() -> float:
	if loaded_data == {}:
		return 1.0
	return master_volume

func get_music_volume() -> float:
	if loaded_data == {}:
		return 1.0
	return music_volume

func get_sfx_volume() -> float:
	if loaded_data == {}:
		return 1.0
	return sfx_volume

func get_keybind(action: String):
	if not loaded_data.has("keybinds"):
		match action:
			keybind_resource.FORWARD:
				return keybind_resource.DEFAULT_FORWARD
			keybind_resource.BACKWARD:
				return keybind_resource.DEFAULT_BACKWARD
			keybind_resource.LEFT:
				return keybind_resource.DEFAULT_LEFT
			keybind_resource.RIGHT:
				return keybind_resource.DEFAULT_RIGHT
			keybind_resource.SPECIAL:
				return keybind_resource.DEFAULT_SPECIAL
			keybind_resource.JUMP:
				return keybind_resource.DEFAULT_JUMP
			keybind_resource.RESET:
				return keybind_resource.DEFAULT_RESET
	else:
		match action:
			keybind_resource.FORWARD:
				return keybind_resource.forward_key
			keybind_resource.BACKWARD:
				return keybind_resource.backward_key
			keybind_resource.LEFT:
				return keybind_resource.left_key
			keybind_resource.RIGHT:
				return keybind_resource.right_key
			keybind_resource.SPECIAL:
				return keybind_resource.special_key
			keybind_resource.JUMP:
				return keybind_resource.jump_key
			keybind_resource.RESET:
				return keybind_resource.reset_key
	
	

func on_window_mode_selected(index: int) -> void:
	window_mode = index

func on_resolution_selected(index: int) -> void:
	resolution = index

func on_master_sound_set(value: float) -> void:
	master_volume = value

func on_music_sound_set(value: float) -> void:
	music_volume = value

func on_sfx_sound_set(value: float) -> void:
	sfx_volume = value

func set_keybind(action: String, event) ->void:
	match action:
		keybind_resource.FORWARD:
			keybind_resource.forward_key = event
		keybind_resource.BACKWARD:
			keybind_resource.backward_key = event
		keybind_resource.LEFT:
			keybind_resource.left_key = event
		keybind_resource.RIGHT:
			keybind_resource.right_key = event
		keybind_resource.SPECIAL:
			keybind_resource.special_key = event
		keybind_resource.JUMP:
			keybind_resource.jump_key = event
		keybind_resource.RESET:
			keybind_resource.reset_key = event


func on_keybinds_loaded(data: Dictionary) -> void:
	var loaded_forward = InputEventKey.new()
	var loaded_backward = InputEventKey.new()
	var loaded_left = InputEventKey.new()
	var loaded_right = InputEventKey.new()
	var loaded_special = InputEventKey.new()
	var loaded_jump = InputEventKey.new()
	var loaded_reset = InputEventKey.new()
	
	loaded_forward.set_physical_keycode(int(data.forward))
	loaded_backward.set_physical_keycode(int(data.backward))
	loaded_left.set_physical_keycode(int(data.left))
	loaded_right.set_physical_keycode(int(data.right))
	loaded_special.set_physical_keycode(int(data.special))
	loaded_jump.set_physical_keycode(int(data.jump))
	loaded_reset.set_physical_keycode(int(data.reset))
	
	keybind_resource.forward_key = loaded_forward
	keybind_resource.backward_key = loaded_backward
	keybind_resource.left_key = loaded_left
	keybind_resource.right_key = loaded_right
	keybind_resource.special_key = loaded_special
	keybind_resource.jump_key = loaded_jump
	keybind_resource.reset_key = loaded_reset


func on_settings_data_loaded(data: Dictionary) ->void:
	loaded_data = data
	on_window_mode_selected(loaded_data.window_mode)
	on_resolution_selected(loaded_data.resolution)
	on_master_sound_set(loaded_data.master_volume)
	on_music_sound_set(loaded_data.music_volume)
	on_sfx_sound_set(loaded_data.sfx_volume)
	on_keybinds_loaded(loaded_data.keybinds)

func handle_signals() -> void:
	SettingsSignals.on_window_mode_selected.connect(on_window_mode_selected)
	SettingsSignals.on_resolution_selected.connect(on_resolution_selected)
	SettingsSignals.on_master_sound_set.connect(on_master_sound_set)
	SettingsSignals.on_music_sound_set.connect(on_music_sound_set)
	SettingsSignals.on_sfx_sound_set.connect(on_sfx_sound_set)
	SettingsSignals.load_settings_data.connect(on_settings_data_loaded)
