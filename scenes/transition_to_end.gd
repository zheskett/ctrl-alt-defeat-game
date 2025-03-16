extends Control

func _ready():
	$AnimationPlayer.play("fadeIn")
	await $AnimationPlayer.animation_finished

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		$AnimationPlayer.play("fadeOut")
		await $AnimationPlayer.animation_finished
		self.hide()
		get_tree().change_scene_to_file("res://scenes/ending.tscn")
