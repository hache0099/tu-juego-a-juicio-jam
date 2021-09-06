extends Node2D

export(Array, PackedScene) var enemies
export(PackedScene) var foquito_hijo
export(PackedScene) var you_win_scene
export(PackedScene) var you_lose_scene

onready var UI = $UI_Layer/UI
onready var ideas_barra = $UI_Layer/UI/Ideas_barra
onready var vida_barra = $UI_Layer/UI/Creador_vida
var curva_dificultad = load("res://curva_dificultad.tres")

const max_semanas : int = 3

enum SPAWN_PLACES {UP, LEFT, RIGHT}

var refill_time : float = 3.0
var semana_actual : int = 0

var spawn_points_vector : Array = []
var focos_siguiendo_player = []

func _ready():
	randomize()
#	$foquito_hijo.set_objeto_a_seguir($Foco)
	set_spawn_points()

func set_spawn_points():
	for i in $spawn_points_node.get_child_count():
		var node = $spawn_points_node.get_child(i)
		spawn_points_vector.append([])
		
		for j in node.get_child_count():
			var position_node = node.get_child(j)
			spawn_points_vector[i].append(position_node.get_position())

func _process(delta):
	if Input.is_action_just_pressed("skip_intro"):
		spawn_enemy(2, Vector2(512,-50))
	UI.get_node("Label").set_text("SEMANA %d" % (semana_actual + 1))

func spawn_enemy(index, pos):
	var e = enemies[index].instance()
	e.position = pos
	e.set_target_pos($objetivo.position)
	$enemies_node.add_child(e)

func spawn_foquito_hijo():
	var f = foquito_hijo.instance()
	
	var rand_pos = Vector2(rand_range(0,$ColorRect.rect_size.x), rand_range(0,$ColorRect.rect_size.y))
	f.position = rand_pos + $ColorRect.rect_position
	f.player = $Foco
	f.connect("change_state", self, "set_foquito_objetivo")
	f.connect("dead", self,"foquito_hijo_dead")
	$foquitos_node.add_child(f)

func foquito_hijo_dead(_foquito):
	focos_siguiendo_player.erase(_foquito)
	if !focos_siguiendo_player.empty():
		focos_siguiendo_player.front().set_objeto_a_seguir($Foco)
		for i in focos_siguiendo_player.size():
			if i > 0:
				focos_siguiendo_player[i].set_objeto_a_seguir(focos_siguiendo_player[i-1])

func set_foquito_objetivo(_foquito_nuevo):
	if focos_siguiendo_player.empty():
		_foquito_nuevo.set_objeto_a_seguir($Foco)
	else:
		_foquito_nuevo.set_objeto_a_seguir(focos_siguiendo_player.back())
	
	focos_siguiendo_player.append(_foquito_nuevo)
	_foquito_nuevo.add_to_group("focos_gang")

func _on_spawn_enemies_timeout():
	var rand_num = randi() % enemies.size()
	var pos_rand = randi() % spawn_points_vector.size()
	var vec_rand = randi() % spawn_points_vector[pos_rand].size()
	spawn_enemy(rand_num, spawn_points_vector[pos_rand][vec_rand])

func _on_objetivo_hit(_vida):
	vida_barra.value = _vida

func _on_barra_vida_refill_timeout():
	if ideas_barra.value < ideas_barra.max_value:
		ideas_barra.value += refill_time
	else:
		ideas_barra.value = 0
		spawn_foquito_hijo()

func subir_dificultad():
	var max_seconds : float = 6.0
	var min_seconds : float = 4.9
	var diferencia : float = max_seconds - min_seconds
	var dificultad = 30.0 * semana_actual / 120.0
	
	var total : float = max_seconds - diferencia * curva_dificultad.interpolate(dificultad)
	
	$spawn_enemies.wait_time = total
	prints(dificultad, $spawn_enemies.wait_time)

func _on_tiempoSemana_timeout():
	var semanaBar = UI.get_node("semanaProgress")
	if semanaBar.value < semanaBar.max_value:
		semanaBar.value += 1
	else:
		semanaBar.value = 0
		if semana_actual < max_semanas:
			semana_actual += 1
			subir_dificultad()
		else:
			get_tree().change_scene_to(you_win_scene)

func curar_objetivo():
	if $objetivo.vida < $objetivo.max_vida:
		$objetivo.vida += 2.5
		vida_barra.value = $objetivo.vida
	else:
		$barra_vida_refill.stop()

func _on_Foco_cambio_estado(estado):
	if estado:
		$barra_vida_refill.start()
	else:
		$barra_vida_refill.stop()

func _on_objetivo_dead():
	$tiempoSemana.stop()
	$spawn_enemies.stop()
	$barra_ideas_refill.stop()
	$barra_vida_refill.stop()
	$UI_Layer/pause.set_process(false)
	
	$Tween.interpolate_property(self,"modulate",null,ColorN("black"),2.0 ,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	get_tree().change_scene_to(you_lose_scene)

func _on_Foco_area_entered(area):
	if area.is_in_group("bullet"):
		$objetivo.player_hit()
