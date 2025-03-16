extends Node2D

func _ready():
	self.show()
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		self.hide()
		get_tree().change_scene_to_file("res://scenes/farming.tscn")
