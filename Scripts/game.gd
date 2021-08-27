extends Node2D

func _ready():
	randomize()
	$enemy_simple_shoot.set_target_pos($objetivo.position)
