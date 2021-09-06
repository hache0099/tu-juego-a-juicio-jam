extends Node

export(PackedScene) var game

#Reutilizo codigo para que MS1 y MS2 se oculten y salgan con diferentes textos
var timer
var timer2 #para evitar que el jugador pueda apagarse y rpednerse y salterase el tuto
var tutorial #boolean para invocar al foquito
var cooldown = 2.5
var flag = true #entrar area
var flag2 = false #matar enemigo
var flag3 = false #agarrar foco y terminar tutorial
var trueapagado = false
var falseapagado = false
var flag4 = false #para el momento de apagado
var flag5 = false #para el momento de prendido

func _ready():
	tutorial = true
	get_tree().paused = false
	get_tree().paused = true
	
	timer= Timer.new()
	add_child(timer)
	
	timer2= Timer.new()
	add_child(timer2)
	#Primer cartel
	$efecto.interpolate_property($Ms1,"rect_position",$Ms1.rect_position,$Ms1.rect_position+Vector2(650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto.start()
	timer.set_one_shot(true)
	timer.set_wait_time(cooldown)
	timer.connect("timeout", self, "salir")
	timer.start()
	timer2.set_wait_time(cooldown+1)
	timer2.set_one_shot(true)
	timer2.connect("timeout", self, "despausar")
	timer2.start()
	
#se activa una vez entras al área
func _on_Area_area_entered(area):
	get_tree().paused = true
	$Area.queue_free()
	$Area.visible = false
	$Ms1.text="Mira una mala idea, ten cuidado"
	$enemy_simple_shoot.canMove = true
	efecto1()
	#= Timer.new()
	#AUN SIGUE EL AREA

#Se supone esta funcion se activa cuando el enemigo muere (PROCESO)
func disparoend():
	#activo 2da bandera
	get_tree().paused = true
	flag2 = true
	$Ms1.text="Bien hecho, \n que la creatividad no pare \n agarra esta otra buena idea "
	efecto1()
	
#Se supone esta funcion se activa cuando agarras el foco (PROCESO)
func focomuerto(foquito):
	#activo 3ra bandera
	flag3 = true
	#trueapagado = true
	get_tree().paused = true
	$Ms1.text="¡QUE HACES!\n ...que parte de fragil no entendistes \n No siempre hay que disparar \n intenta apagarte"
	efecto1()

func Seapago(estado):
	if trueapagado:
		trueapagado = false
		#falseapagado = true
		#activo 4ra bandera
		flag4 = true
		get_tree().paused = true
		$Ms1.text="De este modo \n eres invulnerable \n aunque no podras \n moverte y disparar"
		efecto1()

func Seprendio(estado):
	if falseapagado && !trueapagado:
		falseapagado = false
		#activo el sgte flag
		flag5=true
		get_tree().paused = true
		$Ms1.text="Recuerda estando encendido \n recargas la vida"
		efecto1()

#Reutilizo codigo, uso booleans para que el texto de abajo diga algo distinto
func despausar():
	get_tree().paused = false

func salir():
	if flag:
		$Area.visible = true
		flag = false
	else:
		$Ms2.text="Destruyelo de un disparo \n con el boton Z"
	if flag2:
		$Ms2.text="Recoge esa otra idea, \n es FRAGIL, \n cuidado con DISPARARLE"
		flag2 = false
	if flag3:
		trueapagado = true
		$Ms2.text="Apagate usando X"
		flag3 = false
	if flag4:
		falseapagado=true
		$Ms2.text="Prendete usando X"
		flag4 = false
	if flag5:
		#salgo del tutorial
		get_tree().paused = false
		get_tree().change_scene_to(game)
	efecto2()


func _on_enemy_simple_shoot_enter_to_normal():
#	$enemy_simple_shoot.set_process(false)
	$enemy_simple_shoot.canMove = false

#efecto 1
func efecto1():
	$efecto.interpolate_property($Ms1,"rect_position",$Ms1.rect_position,$Ms1.rect_position+Vector2(650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto.start()
	$efecto4.interpolate_property($Ms2,"rect_position",$Ms2.rect_position,$Ms2.rect_position+Vector2(-650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto4.start()
	timer.set_wait_time(cooldown)
	timer.start()
	timer.set_wait_time(cooldown+1)
	timer2.start()

#efecto 2
func efecto2():
	$efecto2.interpolate_property($Ms1,"rect_position",$Ms1.rect_position,$Ms1.rect_position+Vector2(-650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto2.start()
	$efecto3.interpolate_property($Ms2,"rect_position",$Ms2.rect_position,$Ms2.rect_position+Vector2(650,0),1,Tween.TRANS_BACK,Tween.EASE_IN_OUT)
	$efecto3.start()





