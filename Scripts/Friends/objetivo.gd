extends Area2D

signal dead
signal hit(_vida)

const max_vida : float = 50.0

var vida = 50.0

func _ready():
	$Sprite.playing = true

func set_dead():
	$Sprite.set_animation("dead")
	$Sprite.set_offset(Vector2.ZERO)
	$CPUParticles2D.emitting = true
	emit_signal("dead")

func player_hit():
	vida -= 5.0
	emit_signal("hit", vida)

func _on_objetivo_area_entered(area):
	if vida > 0.0:
		if area.is_in_group("bullet"):
			vida -= 1.0
		elif area.is_in_group("explosion"):
			vida -= 10.0
		emit_signal("hit", vida)
		
		if vida <= 0.0:
			set_dead()
			return
		
		$AnimationPlayer.play("hurt")
