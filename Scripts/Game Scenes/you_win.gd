extends Control
export(PackedScene) var menu

func _ready():
	pass

func _on_menu_pressed():
	$AudioStreamPlayer.stop()
	get_tree().change_scene("res://Scenes/game.tscn")
