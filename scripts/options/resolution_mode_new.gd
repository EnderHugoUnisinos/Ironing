extends Node

const RESOLUTION_DICTIONARY = [
	Vector2i(1920, 1080),
	Vector2i(1280, 720),
	Vector2i(1366, 738)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.item_selected.connect(_item_selected)

func _item_selected(index):
	var window = get_window()
	window.size = RESOLUTION_DICTIONARY[index]
