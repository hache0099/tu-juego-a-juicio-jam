extends Control

export(PackedScene) var menu

func _ready():
	yield(get_tree().create_timer(1.0),"timeout")
	GlobalMusic.get_node("AudioStreamPlayer").play()
	yield(get_tree().create_timer(0.5),"timeout")
	$AnimationPlayer.play("intro_0")

func _process(delta):
	if Input.is_action_just_pressed("skip_intro"):
		get_tree().change_scene_to(menu)
