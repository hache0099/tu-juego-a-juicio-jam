extends "res://Scripts/enemy.gd"

var ray_lenght : float = 50.0

func _ready():
	pass

func _process(delta):
	var move_to = target_position - global_position
	set_move_dir(move_to)
	
	$detectar_objetivo.set_cast_to(move_to.normalized() * ray_lenght)
	
	if $detectar_objetivo.is_colliding():
		dead()

func dead():
	.dead()
	$Sprite.offset = Vector2(0.5,-1)
	$AnimationPlayer.play("explosion")
	$Sprite.play("enemigo_2_xp")

func _on_Sprite_animation_finished():
	if $Sprite.get_animation() == "enemigo_2_xp":
		queue_free()
