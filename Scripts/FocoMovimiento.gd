extends Area2D
export (int) var Velocidad
var Movimiento = Vector2()
var limite

func _ready():
	limite = get_viewport_rect().size
	

func _process(delta):
	Movimiento = Vector2()
	if Input.is_action_pressed("ui_right"):
		Movimiento.x +=1
	if Input.is_action_pressed("ui_left"):
		Movimiento.x -=1
	if Input.is_action_pressed("ui_down"):
		Movimiento.y +=1
	if Input.is_action_pressed("ui_up"):
		Movimiento.y -=1
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
	
	if Movimiento.x < 0:
		
		$AnimatedSprite.animation = "Izquierda"
	elif Movimiento.x > 0:
		$AnimatedSprite.animation = "Derecha"
	else:
		$AnimatedSprite.animation = "Normal"
