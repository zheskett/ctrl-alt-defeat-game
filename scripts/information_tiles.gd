extends Node2D

func _ready():
	self.hide()
	
func show_info():
	self.show()


func _input(event):
	if event is InputEventMouseButton and event.pressed and self.is_visible_in_tree():
		self.hide()
