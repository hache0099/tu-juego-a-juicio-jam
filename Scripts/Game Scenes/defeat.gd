extends Control

func _ready():
	$Tween.interpolate_property(self,"modulate",ColorN("black"),ColorN("white"), 0.5,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,0.5)
	$Tween.start()

func _on_reiniciar_pressed():
	var game = load("res://Scenes/game.tscn")
	$Tween.interpolate_property(self,"modulate",null,ColorN("black"),1.0 ,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	get_tree().change_scene_to(game)
