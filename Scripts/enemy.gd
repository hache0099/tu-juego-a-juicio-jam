# Por ahora es un Area2D, pero tambien podría ser un KineticBody2D

# Esta escena se volverá una clase base para los demás enemigos
extends Area2D

export(int) var vidas = 1
export(float) var velocidad : float = 100.0
export(float) var tiempo_disparo = 1.0

onready var ROOT_GAME = get_node("/root/game")

var bullet = preload("res://Scenes/bullet.tscn")

var canMove = true
var move_direction : Vector2
var target_position : Vector2 setget set_target_pos

func _ready():
	$shootingTime.wait_time = tiempo_disparo

func set_target_pos(pos : Vector2):
	target_position = pos

func set_move_dir(dir):
	if typeof(dir) == TYPE_VECTOR2:
		move_direction = dir
		return
	
	move_direction = polar2cartesian(1,dir)

func _process(delta):
	if canMove:
		position += move_direction.normalized() * velocidad * delta

func move_enemy(delta):
	pass

func shoot():
	pass

func hit():
	pass

func _on_shootingTime_timeout():
	shoot()
#	var v = bullet.instance()
#	v.set_move(move_direction)
#	v.set_position(global_position)
#
#	get_node("/root/game").add_child(v)

func _on_enemy_area_entered(area):
	hit()
