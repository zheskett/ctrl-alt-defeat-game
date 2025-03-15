extends Node2D
class_name Farming

@export var farm_tile_map : FarmTileMapLayer
@export var mouse_crop_sprite : MouseCropSprite
@export var current_crop : Global.Crops = Global.Crops.EMPTY

func _on_cabbage_button_pressed() -> void:
	current_crop = Global.Crops.CABBAGE
	mouse_crop_sprite.visible = true
	mouse_crop_sprite.texture = mouse_crop_sprite.cabbage_texture


func _on_clear_button_pressed() -> void:
	current_crop = Global.Crops.EMPTY
	mouse_crop_sprite.hide()
