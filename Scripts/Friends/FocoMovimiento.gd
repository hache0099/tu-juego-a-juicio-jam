extends Area2D
export (int) var Velocidad
var Movimiento = Vector2()
var limite
#cadencia de disparo
var disparoTIMER
var recarga = true
#velocidad de cadencia de disparo
export  var VELdisparo = 0.35
export  var VELbala = 500
#dirrecion de la bala
var angulo

var encendido = true
signal cambio_estado(estado)

func _ready():
	#no se sale de la pantalla
	limite = get_viewport_rect().size
	#cadencia
	disparoTIMER= Timer.new()
	add_child(disparoTIMER)
	disparoTIMER.set_one_shot(true)
	disparoTIMER.set_wait_time(VELdisparo)
	disparoTIMER.connect("timeout", self, "recargar")
	#inicia el timer
	disparoTIMER.start()

func recargar():
	recarga = true

func invocarbala():
	recarga = false
	var scene = load("res://Scenes/bullet.tscn")
	var bala = scene.instance()
	#self.get_parent.add_child(bala)
	get_tree().get_current_scene().add_child(bala)
	bala.global_position=self.global_position
	bala.MOVE_SPEED = VELbala
	bala.set_collision_mask_bit(5, false)
	bala.set_move(angulo)
	bala.set_bullet_target(true)
	disparoTIMER.start()

func player_hit():
	$Tween.interpolate_property(self,"modulate",null,ColorN("red"), 0.2,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.interpolate_property(self,"modulate",null,ColorN("white"), 0.2,Tween.TRANS_QUAD,Tween.EASE_IN, 0.2)
	$Tween.start()

func _process(delta):
	Movimiento = Vector2()
	if Input.is_action_just_pressed("encender_apagar"):
		encendido = !encendido
		emit_signal("cambio_estado", encendido)
		$CollisionPolygon2D.set_deferred("disabled", !encendido)
		$AnimatedSprite.offset = Vector2(-0.5,-2.5) + Vector2(0,2.0) * float(!encendido)
	
	if encendido:
		if Input.is_action_just_pressed("shoot") && recarga:
			invocarbala()
			
		if Input.is_action_pressed("ui_right"):
			Movimiento.x +=1
			angulo = 0
		if Input.is_action_pressed("ui_left"):
			Movimiento.x -=1
			angulo = 180
		if Input.is_action_pressed("ui_down"):
			Movimiento.y +=1
			angulo = 90
		if Input.is_action_pressed("ui_up"):
			Movimiento.y -=1
			angulo = 270

		if Movimiento.length() > 0:
			Movimiento = Movimiento.normalized()*Velocidad
		position += Movimiento * delta
		position.x =  clamp(position.x, 0, limite.x)
		position.y =  clamp(position.y, 0, limite.y)
		
			#$AnimatedSprite.animation = "Prendiendo"
			#$AnimatedSprite.animation = "Prendido"
			#Notas por si quiero usar espejo vertical u horizontal
			#$AnimatedSprite.flip_h = Movimiento.x < 0
			#$AnimatedSprite.flip_v = false
			
		#ANIMACION
		if recarga == false:
			
			$AnimatedSprite.animation = "Prendiendo"
		else:
			if Movimiento.x < 0:
				$AnimatedSprite.animation = "Derecha"
				$AnimatedSprite.flip_h = true
			elif Movimiento.x > 0:
				$AnimatedSprite.animation = "Derecha"
				$AnimatedSprite.flip_h = false
			else:
				$AnimatedSprite.animation = "Normal"
		
	else:
		$AnimatedSprite.animation = "Apagado"
