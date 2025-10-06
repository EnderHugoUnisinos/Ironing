extends Node

const SETTINGS_SAVE_PATH: String = "user://SettingsData.save"

var settings_data_dict : Dictionary = {}

func _ready():
	SettingsSignals.set_settings_dictionary.connect(on_settings_save)
	load_settings_data()
	
func on_settings_save(data : Dictionary) -> void:
	var settings_data_file = FileAccess.open(SETTINGS_SAVE_PATH, FileAccess.WRITE)
	
	var json_data_string = JSON.stringify(data)
	
	settings_data_file.store_line(json_data_string)

func load_settings_data() -> void:
	if not FileAccess.file_exists(SETTINGS_SAVE_PATH):
		return
	
	var settings_data_file = FileAccess.open(SETTINGS_SAVE_PATH, FileAccess.READ)
	var loaded_data : Dictionary = {}
	
	while settings_data_file.get_position() < settings_data_file.get_length():
		var json_string = settings_data_file.get_line()
		var json = JSON.new()
		var _parsed_result = json.parse(json_string)
		
		loaded_data = json.get_data()
		print(loaded_data)
	
	SettingsSignals.emit_load_settings_data(loaded_data)
	loaded_data = {}
