extends Node2D

# Used an animation YoutTube tutorial by Kron to learn how to create an animation and code it

# Used ChatGPT to create fadeOut_ready and _input() for clicking to continue

@onready var animation_player = $AnimationPlayer
var fadeOut_ready = false

func play_animation():
	animation_player.play("fadeIn")
	await animation_player.animation_finished
	fadeOut_ready = true	
	
func _input(event):
	if fadeOut_ready and event is InputEventMouseButton and event.pressed:
		fadeOut_ready = false
		animation_player.play("fadeOut")
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://scenes/townMeeting.tscn")
	
