extends "res://Scripts/enemy.gd"

func _ready():
	pass

func shoot():
	var b = bullet.instance()
	b.position = global_position
	b.set_move(rand_range(-180,180))
	ROOT_GAME.add_child(b)
