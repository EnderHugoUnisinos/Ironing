extends Control


@onready var option_button: OptionButton = $HBoxContainer/OptionButton as OptionButton
@onready var label: Label = $HBoxContainer/Label as Label

const RESOLUTION_DICTIONARY : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1600 x 900" : Vector2i(1600, 900)
}

func _ready() -> void:
	label.text = "Resolution"
	add_resolution_size_items()


func add_resolution_size_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)


func _on_option_button_item_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
