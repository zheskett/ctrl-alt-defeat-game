extends Control

@onready var dialog_box = $DialogBox


func _ready():
	$AudioStreamPlayer2D.play()
	#get_tree().get_root().add_child.call_deferred(dialog_box)
	
	#NOTE: 4 - Thompson
	await dialog_box.show_dialog(0, "Hello, Director Thompson. This past few seasons our farming community has been working on a strategy to combat climate change.")
	await dialog_box.show_dialog(4, "I'm listening, John. Please, tell me more about how your community has benefitted from this.")
	await dialog_box.show_dialog(0, "We’ve identified crops like corn, beans, yams, and cassava that are suited for the changing weather. We also used ash to fertilize effectively, and planted trees to protect against river flooding.")
	await dialog_box.show_dialog(4, "...")
	
	if (Global.score >= 340):
		await dialog_box.show_dialog(4, "This sounds like an effective strategy! I see how it could benefit other communities in Fiji. We’ll work on incorporating it into the next update of the National Adaptation Policy! Great Work!")
	else:
		await dialog_box.show_dialog(4, "It doesn't look like this strategy benefitted you much. Maybe after you find more success we can revisit the conversation.")
	#self.queue_free()
	get_tree().change_scene_to_file("res://scenes/outro.tscn")
