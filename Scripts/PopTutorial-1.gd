extends Node

#Reutilizo codigo para que MS1 y MS2 se oculten y salgan con diferentes textos
var timer
var tutorial #boolean para invocar al foquito
var cooldown = 3
var flag = true #entrar area
var flag2 = false #matar enemigo
var flag3 = false #agarrar foco y terminar tutorial

func _ready():
	tutorial = true
	get_tree().paused = false
	get_tree().paused = true
	timer= Timer.new()
	add_child(timer)
	#Primer cartel
	$efecto.interpolate_property($Ms1,"rect_position",$Ms1.rect_position,$Ms1.rect_position+Vector2(650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto.start()
	timer.set_one_shot(true)
	timer.set_wait_time(cooldown)
	timer.connect("timeout", self, "salir")
	timer.start()
	
#se activa una vez entras al área
func _on_Area_area_entered(area):
	get_tree().paused = true
	$Area.queue_free()
	$Area.visible = false
	$Ms1.text="Mira una pésima idea, ten cuidado"
	$enemy_simple_shoot.canMove = true
	$efecto.interpolate_property($Ms1,"rect_position",$Ms1.rect_position,$Ms1.rect_position+Vector2(650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto.start()
	$efecto4.interpolate_property($Ms2,"rect_position",$Ms2.rect_position,$Ms2.rect_position+Vector2(-650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto4.start()
	timer.set_wait_time(cooldown)
	timer.start()
	#= Timer.new()
	#AUN SIGUE EL AREA

#Se supone esta funcion se activa cuando el enemigo muere (PROCESO)
func disparoend():
	#activo 2da bandera
	get_tree().paused = true
	flag2 = true
	$Ms1.text="Bien hecho, \n que la creatividad no pare \n agarra esta otra buena idea "
	$efecto.interpolate_property($Ms1,"rect_position",$Ms1.rect_position,$Ms1.rect_position+Vector2(650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto.start()
	$efecto4.interpolate_property($Ms2,"rect_position",$Ms2.rect_position,$Ms2.rect_position+Vector2(-650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto4.start()
	timer.set_wait_time(cooldown)
	timer.start()
	
#Se supone esta funcion se activa cuando agarras el foco (PROCESO)
func focomuerto(foquito):
	#activo 3ra bandera
	flag3 = true
	$Ms1.text="¡QUE HACES!\n ...que parte de fragil no entendistes \n No importa solo \n ten cuidado en el juego"
	$efecto.interpolate_property($Ms1,"rect_position",$Ms1.rect_position,$Ms1.rect_position+Vector2(650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto.start()
	$efecto4.interpolate_property($Ms2,"rect_position",$Ms2.rect_position,$Ms2.rect_position+Vector2(-650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto4.start()
	timer.set_wait_time(cooldown+2) #5 segundos
	timer.start()

#Reutilizo codigo, uso booleans para que el texto de abajo diga algo distinto
func salir():
	get_tree().paused = false
	if flag:
		$Area.visible = true
		flag = false
	else:
		$Ms2.text="Destruyelo de un disparo \n con el boton Z"
	if flag2:
		$Ms2.text="Recoge esa otra idea, \n es FRAGIL, \n cuidado con dispararle"
		flag2 = false
	if flag3:
		#salgo del tutorial
		get_tree().change_scene("res://Scenes/game.tscn")
	$efecto2.interpolate_property($Ms1,"rect_position",$Ms1.rect_position,$Ms1.rect_position+Vector2(-650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto2.start()
	$efecto3.interpolate_property($Ms2,"rect_position",$Ms2.rect_position,$Ms2.rect_position+Vector2(650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto3.start()


func _on_enemy_simple_shoot_enter_to_normal():
#	$enemy_simple_shoot.set_process(false)
	$enemy_simple_shoot.canMove = false

#invocar al foquito

	

