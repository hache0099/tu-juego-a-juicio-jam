extends Area2D

# Por ahora es un const, quizas lo cambie a variable segun avance
const MOVE_SPEED : float = 300.0

var move_direction : Vector2

func _ready():
	pass

func _process(delta):
	position += move_direction.normalized() * MOVE_SPEED * delta

func set_move(dir):
	move_direction = dir
	print(dir)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
