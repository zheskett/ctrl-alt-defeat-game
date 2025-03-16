extends Control 

#Used ChatGPT to learn how to access the animation in orientation in this scene

var animation_scene

func _ready():
	$AudioStreamPlayer2D.play()
	var scene_resource = load("res://scenes/orientation.tscn")
	animation_scene = scene_resource.instantiate()

func _on_play_button_pressed() -> void:
	get_tree().get_root().add_child(animation_scene)
	await animation_scene.play_animation()
