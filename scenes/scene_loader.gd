extends Node

enum Scene {MENU, GARAGEM, SALA, TUTORIAL}
var current_scene : Scene = Scene.MENU

const MENU_SCENE_PATH : String = "res://scenes/new_menus/main_menu.tscn"
const TUTORIAL_SCENE_PATH : String = "res://scenes/nivel/nivel_tutorial.tscn"
const GARAGE_SCENE_PATH : String = "res://scenes/nivel/nivel_garagem.tscn"
const LIVING_ROOM_SCENE_PATH : String = "res://scenes/nivel/nivel_sala_de_estar.tscn"

@onready var end_level_GUI : Control = $EndLevel

var load_scene
var level_dict = {Scene.MENU : null, Scene.GARAGEM : null, Scene.SALA : null, Scene.TUTORIAL : null}

var instanced_scene : Node
var starting_cutscene_played : bool = false
var ending_level : bool = false

var level_time : String = "00:00:00"
var water_level : String = "100%"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(GARAGE_SCENE_PATH)
	ResourceLoader.load_threaded_request(MENU_SCENE_PATH)
	ResourceLoader.load_threaded_request(TUTORIAL_SCENE_PATH)
	ResourceLoader.load_threaded_request(LIVING_ROOM_SCENE_PATH)
	load_main_menu()

func remove_children():
	if instanced_scene:
		call_deferred("remove_child", instanced_scene)

func instantiate_scene():
	end_level_GUI.visible = false
	get_tree().paused = false
	instanced_scene = load_scene.instantiate()
	add_child(instanced_scene)
	move_child(end_level_GUI, get_child_count()-1)

func load_main_menu():
	current_scene = Scene.MENU
	remove_children()
	if !level_dict[Scene.MENU]:
		level_dict[Scene.MENU] = ResourceLoader.load_threaded_get(MENU_SCENE_PATH)
	load_scene = level_dict[Scene.MENU]
	instantiate_scene()

func load_tutorial():
	current_scene = Scene.TUTORIAL
	starting_cutscene_played = false
	remove_children()
	if !level_dict[Scene.TUTORIAL]:
		level_dict[Scene.TUTORIAL] = ResourceLoader.load_threaded_get(TUTORIAL_SCENE_PATH)
	load_scene = level_dict[Scene.TUTORIAL]
	instantiate_scene()

func load_level_0():
	current_scene = Scene.GARAGEM
	starting_cutscene_played = false
	remove_children()
	if !level_dict[Scene.GARAGEM]:
		level_dict[Scene.GARAGEM] = ResourceLoader.load_threaded_get(GARAGE_SCENE_PATH)
	load_scene = level_dict[Scene.GARAGEM]
	instantiate_scene()

func load_level_1():
	current_scene = Scene.SALA
	starting_cutscene_played = false
	remove_children()
	if !level_dict[Scene.SALA]:
		level_dict[Scene.SALA] = ResourceLoader.load_threaded_get(LIVING_ROOM_SCENE_PATH)
	load_scene = level_dict[Scene.SALA]
	instantiate_scene()

func reload_scene():
	starting_cutscene_played = true
	remove_children()
	instantiate_scene()

func end_level():
	ending_level = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$EndLevel.visible = true
	$EndLevel.end_level(level_time)
