extends Control


@onready var option_button: OptionButton = $HBoxContainer/OptionButton as OptionButton
@onready var label: Label = $HBoxContainer/Label as Label

const WINDOW_MODE_ARRAY : Array[String] = [
	"Fullscreen",
	"Windowed",
	"Borderless Windowed",
	"Borderless Fullscreen"
]

func _ready() -> void:
	label.text = "Window"
	add_window_mode_items()


func add_window_mode_items() -> void:
	for window_mode in WINDOW_MODE_ARRAY:
		option_button.add_item(window_mode)


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #Borderless Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #Borderless Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
