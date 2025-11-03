class_name LevelChoice

extends Control

@onready var panel: Panel = $VBoxContainer/Panel
@onready var label: Label = $VBoxContainer/Label


@export var level_name: String = "LVL 0"
@export var level_path: String = "res://scenes/test_scene.tscn"

func _ready() ->void:
	set_level_name()


func set_level_name() -> void:
	label.text = level_name

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("open_menu") and self.visible == true:
		self.visible = false

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(level_path)
