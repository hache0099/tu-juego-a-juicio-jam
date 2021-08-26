extends Node2D

func _ready():
	$enemy.target_pos = $objetivo.position
