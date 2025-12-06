class_name Surface
extends Node3D

var speed_increase : float
var speed_decrease : float
var drain : float
var jump : float
var slip : float

func surface_iron(player):
	player.floor_max_angle = deg_to_rad(50)
	pass

func surface_walk(player):
	player.floor_max_angle = deg_to_rad(50)
	pass

func surface_jump(player):
	player.floor_max_angle = deg_to_rad(50)
	pass

func ramp():
	pass
