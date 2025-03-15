extends Control

#Used a tutorial by scriptblocks on YouTube to create dialog boxes

@onready var Name = $"ColorRect/Dialog Box/Name"
@onready var Text = $"ColorRect/Dialog Box/Text"
@onready var face = $"ColorRect/Dialog Box/Face"

var dialogSpeed = 0.5
var dialog
var phraseNum = 0
var finished = false

enum CHAR {
	JOHN, #John
	MEM1, #Community member 1
	MEM2, #Community member 2
	MEM3  #Community member 3
}

#Used ChatGPT to create dictionary for each character
var characters = { #TODO: fix the image paths !!!
	CHAR.JOHN: { "name": "John", "image": "res://assets/" },
	CHAR.MEM1: { "name": "Community Member 1", "image": "res://assets/" }, 
	CHAR.MEM2: { "name": "Community Member 2", "image": "res://assets/" },
	CHAR.MEM3: { "name": "Community Member 3", "image": "res://assets/" }
}

var Message = ""

#Used ChatGPT to create show_dialog()
func show_dialog(char: int, message: String):
	Message = message
	if char in characters:
		var character = characters[char]
		Name.text = character["name"] #load name
		face.texture = load(character["image"]) #load facial image
	finished = false
	Text.text = ""
	for i in range(message.length()):
		Text.text += message[i]
		await get_tree().create_timer(dialogSpeed).timeout
	finished = true
	
#Used ChatGPT to create _input() to skip to end of text display
func _input(event): #make player able to click to skip
	if event is InputEventMouseButton and event.pressed:
		if not finished and Message != null:
			Text.text = Message
