extends Area2D

const SPEED : float = 100.0

var target_pos : Vector2 = Vector2()
var move_direction = Vector2()

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("click"):
		target_pos = get_global_mouse_position()
	
	var move_direction = target_pos - position
	if move_direction.length() > 10:
		position += move_direction.normalized() * SPEED * delta
