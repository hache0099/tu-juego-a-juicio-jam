extends "res://Scripts/Enemy/enemy.gd"

var ray_lenght : float = 70.0
# limit_rect se usa para limitar el movimiento de este enemigo a un area determinada
# por su posicion y tamaño
var limit_rect : Rect2
var last_change : Vector2
var distancia_antes_de_cambio : float

func _ready():
	limit_rect.position = Vector2(90,70)
	limit_rect.size = (get_viewport_rect().size - Vector2(180,180)) * Vector2(1, 0.65)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		hit()
	if canMove:
		revolotear()

	var travel = last_change - global_position
	
	if travel.length() > distancia_antes_de_cambio:
		choose_random_dir()

func choose_random_dir():
	distancia_antes_de_cambio = rand_range(200.0,500.0)
	last_change = global_position
	set_move_dir(move_direction.angle() - deg2rad(rand_range(-180,180)))

func revolotear():
	$position_to_move.position = polar2cartesian(ray_lenght, move_direction.angle())
	
	if !limit_rect.has_point($position_to_move.global_position):
		choose_random_dir()

func shoot():
#	var bullet_spread_offset = 15.0
	$shoot_sound.play()
	var target_vec = target_position - global_position
#	var cantidad_balas : int = 2
#
#	for i in cantidad_balas + 1:
#		var middle_angle : float = rad2deg(target_vec.angle())
#		var start_angle = middle_angle - bullet_spread_offset
#		var finish_angle = middle_angle + bullet_spread_offset
#		var angle_to_shoot = finish_angle - start_angle
	
	var b = bullet.instance()
	b.position = global_position
	b.set_bullet_target(false)
	b.set_bullet_enemy(0)
	b.set_move(target_vec)
	ROOT_GAME.add_child(b)
