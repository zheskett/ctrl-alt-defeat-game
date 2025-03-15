extends Control 

var animation_scene = preload("res://scenes/orientation.tscn").instantiate()

func _ready():
	get_tree().get_root().add_child(animation_scene)

func _on_play_button_pressed() -> void:
	animation_scene.play_animation()
	#pass # Replace with function body.
