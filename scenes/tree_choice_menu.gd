extends Control


func _on_yes_pressed() -> void:
	Global.planted_trees = true
	Global.make_tree_choice()
	self.queue_free()


func _on_no_pressed() -> void:
	Global.planted_trees = false
	Global.make_tree_choice()
	self.queue_free()
