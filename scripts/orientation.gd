extends Node2D

func ready():
	$AnimationPlayer.play("fadeIn")
	await(get_tree().create_timer(6))
	$AnimationPlayer.play("fadeOut")
	await(get_tree().create_timer(6))
	#get_tree().change_scene() #TODO: add correct path
	
