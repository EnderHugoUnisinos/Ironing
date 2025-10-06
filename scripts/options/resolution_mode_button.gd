extends Control



@onready var option_button: OptionButton = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1600 x 900" : Vector2i(1600, 900)
}

func _ready() -> void:
	add_resolution_size_items()
	load_data()

func load_data() -> void:
	_on_option_button_item_selected(SettingsData.get_resolution())
	option_button.select(SettingsData.get_resolution())

func add_resolution_size_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)


func _on_option_button_item_selected(index: int) -> void:
	SettingsSignals.emit_resolution(index)
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
