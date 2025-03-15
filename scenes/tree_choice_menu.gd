extends Control

static var plantedTrees = false


func _on_yes_pressed() -> void:
	plantedTrees = true
	self.hide()


func _on_no_pressed() -> void:
	self.hide()
