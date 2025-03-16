extends Control

@onready var dialog_box = $DialogBox


func _ready():
	$AudioStreamPlayer2D.play()
	#get_tree().get_root().add_child.call_deferred(dialog_box)
	
	#NOTE: 4 - Thompson
	await dialog_box.show_dialog(0, "Good afternoon, Director Thompson. We've been testing crops resilient to drought, heat, and flooding, and have developed a local strategy that we believe should be part of the National Adaptation Policy.")
	await dialog_box.show_dialog(4, "I'm listening, John. Please, tell me more about how your community has benefitted from this.")
	await dialog_box.show_dialog(0, "We’ve identified crops like Corn, Beans, Yam, and Cassava that are best suited for these weather conditions. Our strategy emphasizes integrating local testing and knowledge to build resilience for our community’s needs.")
	await dialog_box.show_dialog(4, "...")
	
	#TODO: implement conditional for success or failure
	await dialog_box.show_dialog(4, "This looks like a well-developed approach! I see how it could benefit other communities across the country. We’ll work on incorporating it into the next update of the National Adaptation Policy! Great Work!")
	
	#self.queue_free()
	get_tree().change_scene_to_file("res://scenes/outro.tscn")
