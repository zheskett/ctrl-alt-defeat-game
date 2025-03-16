extends Control

@onready var dialog_box = $"Welcome Message"
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@onready var audio = $AudioStreamPlayer2D

#Used Google Gemini to set up script for the timer and audio
func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(0.1))
	#first play sound
	#timer.connect("timeout", _stop_audio)
	audio.play()
	animation_player.play("soundFade")
	
	#John
	await dialog_box.show_dialog(0, "Welcome, everyone. We have gathered today to discuss the future of our village and how we can adapt to the climate challenges we're facing.")
	await dialog_box.show_dialog(0, "The situation is worsening – from rising sea levels to more extreme weather. The National Adaptaion Plan doesn't address these situations.")
	await dialog_box.show_dialog(0, "We need to come together and find a solution.")
	
	#Litia
	await dialog_box.show_dialog(1, "We’ve always relied on our traditional knowledge to guide us. Our elders taught us to understand the weather patterns, the signs from nature.")
	await dialog_box.show_dialog(1, "We can forecast storms and droughts from changes in the winds or animal behavior. Maybe we should go back to those roots and make use of what our ancestors knew.")
	
	#Saimoni
	await dialog_box.show_dialog(2, "Yes, but we also need to think about the land. We’ve been using soil management techniques, like fallowing practices, to give the soil a break.")
	#await dialog_box.show_dialog(2, "This helps the land recover, and it prevents erosion. It's something we can do to protect our crops and ensure a good harvest.")
	
	#Ana
	await dialog_box.show_dialog(3, "I think we need to diversify our farming. A mixed farming approach –backyard gardening, livestock farming– can help spread the risks.")
	
	#John
	await dialog_box.show_dialog(0, "These are great ideas, everyone. What if we combine all of these suggestions into a single plan?")
	await dialog_box.show_dialog(0, "We'll plant drought-resistant crops, implement mixed cropping to help the soil, and add ashes to the soil as pest protection.")
	await dialog_box.show_dialog(0, "Let’s start working. Together, we’ll make sure Votua stays strong and resilient in the face of these challenges.")
	
	animation_player.play("fadeOut")
	await animation_player.animation_finished
	
	self.hide()
	get_tree().change_scene_to_file("res://scenes/farming.tscn")


	
	
