extends Control

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
var fadeOut_ready = false

func _ready():
	fadeOut_ready = false
	animation_player.play("theEndFadein")
	await animation_player.animation_finished
	timer.start()
	await timer.timeout
	animation_player.play("fadeIn")
	await animation_player.animation_finished
	fadeOut_ready = true
	
func _input(event):
	if fadeOut_ready and event is InputEventMouseButton and event.pressed:
		fadeOut_ready = false
		animation_player.play("fadeOut")
		await animation_player.animation_finished
		get_tree().change_scene_to_file("res://scenes/exitMenu.tscn")

	
