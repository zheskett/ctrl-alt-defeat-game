extends Node2D
class_name Farming

@export var farm_tile_map: FarmTileMapLayer
@export var mouse_crop_sprite: MouseCropSprite
@export var current_crop: Global.Crops = Global.Crops.EMPTY

var score = 0
var is_planting = true
var is_growing = false
var is_harvesting = false

func reset_farming() -> void:
	for plot in farm_tile_map.plot_coords.values():
		(plot as Plot).reset_plot()

	score = 0
	is_harvesting = false
	is_planting = true

func _on_yam_button_pressed() -> void:
	if is_planting:
		current_crop = Global.Crops.YAM
		mouse_crop_sprite.visible = true
		mouse_crop_sprite.texture = mouse_crop_sprite.yam_texture

func _on_clear_button_pressed() -> void:
	current_crop = Global.Crops.EMPTY
	mouse_crop_sprite.hide()

func _on_next_button_pressed() -> void:
	self.is_planting = false
	current_crop = Global.Crops.EMPTY
	mouse_crop_sprite.hide()
	self.is_harvesting = true
