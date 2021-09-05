# Por ahora es un Area2D, pero tambien podría ser un KineticBody2D

# Esta escena se volverá una clase base para los demás enemigos
extends Area2D

signal dead
signal enter_to_normal

enum states {ENTER_SCENE, NORMAL}

export(states) var currentState = states.ENTER_SCENE

export(bool) var canMove = true
export(bool) var can_shoot = true
export(int) var vidas = 1
export(float) var velocidad : float = 100.0
export(float) var tiempo_disparo = 1.0
export(int, 2) var broke_sprite_frame = 0
export(bool) var play_particles = true
export(Color, RGBA) var particle_color = Color(1,1,1,0.8)

onready var ROOT_GAME = get_tree().get_current_scene()

var bullet = preload("res://Scenes/bullet.tscn")

var scene_rect = Rect2(Vector2(50,54), Vector2(922,497))

var move_direction : Vector2 setget set_move_dir
var target_position : Vector2 setget set_target_pos

func _ready():
	$shootingTime.wait_time = tiempo_disparo
#	if !can_shoot:
#		$shootingTime.stop()

func set_target_pos(pos : Vector2):
	target_position = pos

func set_move_dir(dir):
	if typeof(dir) == TYPE_VECTOR2:
		move_direction = dir
		return
	
	move_direction = polar2cartesian(1,dir)

func _process(delta):
	if currentState == states.ENTER_SCENE:
		var _rect = $check_enter_rect.get_global_rect()
		
		if canMove:
			move_to_scene(delta)
		
		if _rect.intersects(scene_rect):
			currentState = states.NORMAL
			if can_shoot:
				$shootingTime.start()
			$CollisionShape2D.disabled = false
			emit_signal("enter_to_normal")
	else:
		if canMove:
			move_enemy(delta)

func move_to_scene(delta):
	var pos_to_center = scene_rect.size / 2 + scene_rect.position
	var vec_to_center = pos_to_center - global_position
	
	var vertical_dot = vec_to_center.normalized().dot(Vector2.DOWN)
	var horizontal_dot = vec_to_center.normalized().dot(Vector2.RIGHT)
	
	var direction_to_enter : Vector2
	
	if abs(vertical_dot) > abs(horizontal_dot):
		set_move_dir(Vector2.DOWN)
	else:
		set_move_dir(Vector2.RIGHT * sign(horizontal_dot))
	
	position += move_direction.normalized() * velocidad * delta


func move_enemy(delta):
	position += move_direction.normalized() * velocidad * delta

func shoot():
	pass

func hit():
	if vidas > 1:
		vidas -= 1
		$Tween.interpolate_property(self,"modulate",null,ColorN("red"), 0.2,Tween.TRANS_QUAD,Tween.EASE_OUT)
		$Tween.interpolate_property(self,"modulate",null,ColorN("white"), 0.2,Tween.TRANS_QUAD,Tween.EASE_IN, 0.2)
		$Tween.start()
	else:
		$CollisionShape2D.set_deferred("disabled", true)
		dead()
		emit_signal("dead")

func dead():
#	set_process(false)
	canMove = false
	$shootingTime.stop()
	$dead_sound.play()
	$CollisionShape2D.set_deferred("disabled", true)
	
	if play_particles:
		set_particles()
		set_broke_sprite()
		
#		var dead_anim = Tween.new()
#		add_child(dead_anim)
		
		$Tween.interpolate_property(self,"modulate",null,Color(1.0,1.0,1.0,0.0), 3,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, 2.0)
		$Tween.start()
		yield($Tween,"tween_all_completed")
		queue_free()
	

func set_broke_sprite():
	$Sprite.set_sprite_frames(load("res://broke_spriteframes.tres"))
	$Sprite.set_animation("broke_sprite")
	$Sprite._set_playing(false)
	
	if broke_sprite_frame > 0:
		$Sprite.set_frame(broke_sprite_frame - 1)

func set_particles():
	$CPUParticles2D.set_color(particle_color)
	$CPUParticles2D.set_emitting(true)

func _on_shootingTime_timeout():
	shoot()

func _on_enemy_area_entered(area):
	if area.is_in_group("bullet") and area.get_collision_mask_bit(1):
		hit()
