extends Control

@onready var dialog_box = $DialogBox
@onready var tree_decision = $TreeChoiceMenu


func _ready():
	tree_decision.hide()
	await dialog_box.show_dialog(1, "In recent years, the river has been known to flood. Planting trees along the shoreline can help protect agasint that. You might want to consider it!")
	tree_decision.show()
	
