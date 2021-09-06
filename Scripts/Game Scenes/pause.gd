extends Control

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pausar()

func pausar():
	var paused = get_tree().is_paused()
	visible = !visible
	get_tree().set_pause(!paused)

func _on_continue_pressed():
	pausar()

func _on_reiniciar_pressed():
	pausar()
	get_tree().reload_current_scene()
