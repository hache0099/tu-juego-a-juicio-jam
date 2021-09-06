extends Area2D

signal change_state(foquito)
signal dead(foquito)

const MAX_VEL = 300.0
const max_vidas : int = 0

var objeto_a_seguir
var player
var puede_seguir : bool = false
var velocidad : float = 0
var min_distance : float = 75.0
var vidas = max_vidas

func _ready():
	$AnimatedSprite.play("spawned")

func set_objeto_a_seguir(objecto):
	objeto_a_seguir = objecto

func set_player(_player):
	player = _player

func dead():
	puede_seguir = false
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.set_animation("dead")
	$AnimatedSprite._set_playing(false)
	$CPUParticles2D.emitting = true
	$Tween.interpolate_property($AnimatedSprite,"modulate",null,Color(1.0,1.0,1.0,0.0), 2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,1)
	$Tween.start()

func hit():
	$Tween.interpolate_property($AnimatedSprite,"modulate",null, ColorN("red"), 0.2,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.interpolate_property($AnimatedSprite,"modulate",null, ColorN("white"), 0.2,Tween.TRANS_QUAD,Tween.EASE_IN, 0.2)
	$Tween.start()

func _process(delta):
	if puede_seguir and objeto_a_seguir:
		var move_dir = objeto_a_seguir.position - global_position
		
		if move_dir.length() > min_distance:
			velocidad = move_toward(velocidad, MAX_VEL, 10.0)
		else:
			velocidad = move_toward(velocidad, 0, 17.0)
		
		position += move_dir.normalized() * velocidad * delta
		
		if player:
			if player.encendido:
				$AnimatedSprite.set_animation("encendido")
			else:
				$AnimatedSprite.set_animation("apagado")

func _on_foquito_hijo_area_entered(area):
	if area.is_in_group("bullet") and puede_seguir:
		if vidas > 0:
			vidas -= 1
			hit()
		else:
			dead()
			emit_signal("dead", self)
	
	if area.is_in_group("explosion"):
		dead()
		emit_signal("dead", self)
	
	if area.is_in_group("player") and !puede_seguir:
		puede_seguir = true
		emit_signal("change_state", self)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "spawned":
		$AnimatedSprite.play("idle")


func _on_enemy_simple_shoot_dead():
	position.x = 800
	position.y = 200
	$AnimatedSprite.play("spawned")
