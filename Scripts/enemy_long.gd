extends "res://Scripts/enemy.gd"

var time_between_shoots : float = 2.0
var max_bullets : int = 4
var bullets_left = 4
var current_pos : Vector2
var distance_to_travel : float
var new_angle : float

func _ready():
	bullets_left = max_bullets

func dead():
	can_shoot = false
	.dead()

func select_angle():
	var angle = rad2deg(move_direction.angle())
	var spread_angle = 25.0
	distance_to_travel = rand_range(100.0,250.0)
	new_angle = rand_range(angle - spread_angle, angle + spread_angle)
	
	current_pos = global_position

func _process(delta):
	if currentState == states.NORMAL:
		var travel = current_pos - global_position
		if travel.length() < distance_to_travel:
			set_move_dir(polar2cartesian(1, deg2rad(new_angle)))
		else:
			velocidad = 0.0

func rafaga():
	if bullets_left > 0:
		if $shootingTime.wait_time != tiempo_disparo:
			$shootingTime.stop()
			$shootingTime.start(tiempo_disparo)
		
		var b = bullet.instance()
		b.position = global_position
		b.set_bullet_target(false)
		b.set_move(target_position - global_position)
		ROOT_GAME.add_child(b)
		
		bullets_left -= 1
		return
	
	else:
		$shootingTime.stop()
		$shootingTime.start(time_between_shoots)
		bullets_left = max_bullets
		return

func shoot():
#	if can_shoot:
#		rafaga()
	$shoot_sound.play()
	var bullet_spread_offset = 15.0
	var target_vec = target_position - global_position
	var cantidad_balas : int = 2
	
	for i in cantidad_balas + 1:
		var middle_angle : float = rad2deg(target_vec.angle())
		var start_angle = middle_angle - bullet_spread_offset
		var finish_angle = middle_angle + bullet_spread_offset
		var angle_to_shoot = finish_angle - start_angle
		
		var b = bullet.instance()
		b.position = global_position
		b.set_bullet_target(false)
		b.set_bullet_enemy(1)
		b.set_move((angle_to_shoot / cantidad_balas * i) + start_angle)
		ROOT_GAME.add_child(b)

func _on_enemy_long_enter_to_normal():
	select_angle()
