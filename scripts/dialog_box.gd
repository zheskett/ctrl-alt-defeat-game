extends Control

#Used a tutorial by scriptblocks on YouTube to create dialog boxes

@onready var Name = $"ColorRect/Dialog Box/Name"
@onready var Text = $"ColorRect/Dialog Box/Text"
@onready var face = $"ColorRect/Dialog Box/Face"

var dialogSpeed = 0.03125
var dialog
var phraseNum = 0
var finished = false

#Used ChatGPT to figure out how to use signals to wait for user confirmation
signal dialog_finished

enum CHAR {
	JOHN, #John
	MEM1, #Community member 1
	MEM2, #Community member 2
	MEM3,  #Community member 3
	Thompson #director
}

#Used ChatGPT to create dictionary for each character
var characters = { #TODO: fix the image paths !!!
	CHAR.JOHN: { "name": "John", "image": "res://assets/temp_art/sketchana.png" },
	CHAR.MEM1: { "name": "Litia", "image": "res://assets/temp_art/sketchana.png" }, 
	CHAR.MEM2: { "name": "Saimoni", "image": "res://assets/temp_art/sketchana.png" },
	CHAR.MEM3: { "name": "Ana", "image": "res://assets/temp_art/sketchana.png" },
	CHAR.Thompson: { "name" : "Thompson", "image": "res://assets/temp_art/sketchana.png"}
}

var Message = ""

func _ready():
	self.hide()

#Used ChatGPT to create show_dialog()
func show_dialog(charid: int, message: String):
	self.show()
	Message = message
	if charid in characters and Name and Text and face:
		var character = characters[charid]
		Name.text = character["name"] #load name
		face.texture = load(character["image"]) #load facial image
		finished = false
		Text.text = ""
		for i in range(message.length()):
			if not finished:
				Text.text += message[i]
				await get_tree().create_timer(dialogSpeed).timeout
		finished = true
		
		await self.dialog_finished
		self.hide()
	
#Used ChatGPT to create _input() to skip to end of text display
func _input(event): #make player able to click to skip
	if event is InputEventMouseButton and event.pressed:
		if not finished and Message != null:
			Text.text = Message
			finished = true
		elif finished: #Used ChatGPT to figure out how to use signals to wait for user confirmation
			emit_signal("dialog_finished")
