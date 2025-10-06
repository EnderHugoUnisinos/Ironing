extends Node

signal on_window_mode_selected(index: int)

signal on_resolution_selected(index: int)

signal on_master_sound_set(value: float)

signal on_music_sound_set(value: float)

signal on_sfx_sound_set(value: float)

signal set_settings_dictionary(settings_dict : Dictionary)

signal load_settings_data(settings_dict: Dictionary)

func emit_window_mode(index: int) -> void:
	on_window_mode_selected.emit(index)
	
func emit_resolution(index: int) -> void:
	on_resolution_selected.emit(index)

func emit_master_sound(value: float) -> void:
	on_master_sound_set.emit(value)

func emit_music_sound(value: float) -> void:
	on_music_sound_set.emit(value)

func emit_sfx_sound(value: float) -> void:
	on_sfx_sound_set.emit(value)
	
func emit_set_settings_dictionary(settings_dict : Dictionary) -> void:
	set_settings_dictionary.emit(settings_dict)
	
func emit_load_settings_data(settings_dict: Dictionary) -> void:
	load_settings_data.emit(settings_dict)
