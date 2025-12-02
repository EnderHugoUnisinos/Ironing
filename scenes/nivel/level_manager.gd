extends Node3D

@onready var path_follow = $IntroPath/PathFollow3D
@onready var camera = $IntroPath/PathFollow3D/Camera3D
@onready var player = $Character_Iron

var starting_cutscene_played : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	path_follow.progress_ratio = 0
	if !get_parent().starting_cutscene_played:
		get_tree().paused = true
		run_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !get_parent().starting_cutscene_played:
		path_follow.progress_ratio += 0.1*delta
		if path_follow.progress_ratio >= 0.95:
			starting_cutscene_played = true
			get_parent().starting_cutscene_played = true
			get_tree().paused = false
			player.camera.make_current()

func run_animation():
	camera.make_current()
