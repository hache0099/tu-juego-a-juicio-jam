extends Area2D

# Por ahora es un const, quizas lo cambie a variable segun avance
#SI OCURRE ALGUN ERROR ES AQUI PORQUE QUITE EL CONST
export var MOVE_SPEED : float = 300.0

var move_direction : Vector2


func _process(delta):
	position += move_direction.normalized() * MOVE_SPEED * delta

# Esta funcion configura a quien hace daño la bala
# Recordá checar las collision layer y collision mask
func set_bullet_target(is_player : bool):
	set_collision_mask_bit(0, !is_player)
	set_collision_mask_bit(1, is_player)

# Puede recibir un Vector2 y un float (ángulo de disparo en grados)
func set_move(dir):
	if typeof(dir) == TYPE_VECTOR2:
		move_direction = dir
		return
	
	move_direction = polar2cartesian(1, deg2rad(dir))
	rotation_degrees = dir + 90

func set_bullet_enemy(idx):
	var frame = $Sprite.get_sprite_frames().get_animation_names()
	$Sprite.set_animation(frame[idx])

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_bullet_area_entered(area):
	# provisional hasta que encuentre un mejor metodo
	for i in 1:
		if area.get_collision_layer_bit(i) == get_collision_mask_bit(i):
			queue_free()
