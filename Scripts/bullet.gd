extends Area2D

# Por ahora es un const, quizas lo cambie a variable segun avance
const MOVE_SPEED : float = 300.0

var move_direction : Vector2

func _process(delta):
	position += move_direction.normalized() * MOVE_SPEED * delta

# Puede recibir un Vector2 y un float (ángulo de disparo)
func set_move(dir):
	if typeof(dir) == TYPE_VECTOR2:
		move_direction = dir
		return
	
	move_direction = polar2cartesian(1, dir)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_bullet_area_entered(area):
#	queue_free()
	pass
