# Por ahora es un Area2D, pero tambien podría ser un KineticBody2D

# Esta escena se volverá una clase base para los demás enemigos
extends Area2D

export(int) var vidas = 1
export(float) var velocidad : float = 100.0

var bullet = preload("res://Scenes/bullet.tscn")

var target_pos : Vector2 = Vector2()
var move_direction : Vector2

func _ready():
	pass

func _process(delta):
	move_direction = target_pos - global_position
	if move_direction.length() > 10:
		position += move_direction.normalized() * velocidad * delta

func _on_shootingTime_timeout():
	var v = bullet.instance()
	v.set_move(move_direction)
	v.set_position(global_position)

	get_node("/root/game").add_child(v)
