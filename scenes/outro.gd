extends Control

@onready var animation_player = $AnimationPlayer
var fadeOut_ready = false

func _ready():
	$AudioStreamPlayer2D.play()
	animation_player.play("fadeIn")
	await animation_player.animation_finished
	fadeOut_ready = true
	
func _input(event):
	if fadeOut_ready and event is InputEventMouseButton and event.pressed:
		fadeOut_ready = false
		animation_player.play("fadeOut")
		await animation_player.animation_finished
	
