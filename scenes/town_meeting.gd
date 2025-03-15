extends Control

@onready var dialog_box = preload("res://scenes/dialogBox.tscn").instantiate()

func _ready():
	get_tree().get_root().add_child(dialog_box)
	dialog_box.show_dialog(0, "Welcome to the jungle")
