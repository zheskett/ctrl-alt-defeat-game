extends Control




func _on_exit_pressed() -> void:
	get_tree().quit()



func _on_play_again_pressed() -> void:
	Global.reset()
