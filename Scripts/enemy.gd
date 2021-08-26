# Por ahora es un Area2D, pero tambien podría ser un KineticBody2D
extends Area2D

var bullet = preload("res://Scenes/bullet.tscn")

const SPEED : float = 100.0

var target_pos : Vector2 = Vector2()
var move_direction : Vector2

func _ready():
	pass

func _process(delta):
	move_direction = target_pos - global_position
	if move_direction.length() > 10:
		position += move_direction.normalized() * SPEED * delta

func _on_shootingTime_timeout():
	var v = bullet.instance()
	v.set_move(move_direction)
	v.set_position(global_position)

	get_node("/root/game").add_child(v)
