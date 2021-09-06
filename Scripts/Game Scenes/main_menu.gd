extends Control

export(PackedScene) var game

func _ready():
	pass

func _on_play_pressed():
	GlobalMusic.get_node("AudioStreamPlayer").stop()
	get_tree().change_scene_to(game)

func _on_options_pressed():
	$Popup.popup()

func _on_Popup_visibility_changed():
	$menu_animated.visible = !$Popup.visible
	$VBoxContainer.visible = !$Popup.visible

func _on_popup_close_pressed():
	$Popup.hide()

func _on_salir_pressed():
	get_tree().quit()

func _on_volume_slider_value_changed(value, extra_arg_0):
	AudioServer.set_bus_volume_db(extra_arg_0, linear2db(value))
