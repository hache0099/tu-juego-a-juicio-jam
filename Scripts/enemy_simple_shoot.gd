extends "res://Scripts/enemy.gd"

var ray_lenght : float = 70.0
var limit_rect : Rect2
var last_change : Vector2

func _ready():
	set_move_dir(polar2cartesian(1,rad2deg(-3)))
	limit_rect.position = Vector2(90,70)
	limit_rect.size = (get_viewport_rect().size - Vector2(180,180)) * Vector2(1,0.5)

func choose_random_dir():
	last_change = global_position
	set_move_dir(move_direction.angle() - deg2rad(rand_range(-180,180)))

func revolotear():
	$position_to_move.position = polar2cartesian(ray_lenght, move_direction.angle())
	
	if !limit_rect.has_point($position_to_move.global_position):
		choose_random_dir()

func _process(delta):
	if canMove:
		revolotear()

	var travel = last_change - global_position
	
	if travel.length() > 250.0:
		choose_random_dir()

func shoot():
	var b = bullet.instance()
	b.position = global_position
	b.set_move(target_position - global_position)
	ROOT_GAME.add_child(b)
