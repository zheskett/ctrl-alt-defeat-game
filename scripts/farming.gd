extends Node2D
class_name Farming


@export var farm_tile_map: FarmTileMapLayer
@export var mouse_crop_sprite: MouseCropSprite
@export var score_label: Label
@export var water_label: Label
@export var current_crop: Global.Crops = Global.Crops.EMPTY

var score: int = 0:
	set(value):
		score = value
		score_label.text = "Score: " + str(score)

var year = 1
var is_planting := true
var is_growing := false
var is_harvesting := false
var is_watering := false
const MAX_WATER := 300
var water := 0 :
	set(value):
		water = value
		water_label.text = str(water_percent) + "%"
var water_percent : int :
	get:
		return int((water as float) / (MAX_WATER as float) * 100.0)

func _physics_process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_watering:
		water -= 1
		if water <= 0:
			is_watering = false
			mouse_crop_sprite.hide()

func _ready() -> void:
	year = 1
	score = 0
	reset_farming()


func plant_planted() -> void:
	# Detect full farm
	for plot in farm_tile_map.plot_coords.values():
		if (plot as Plot).crop == Global.Crops.EMPTY or (plot as Plot).harvested == true:
			return
	
	if is_planting:
		self.is_planting = false
		current_crop = Global.Crops.EMPTY
		mouse_crop_sprite.hide()
		self.is_growing = true


func reset_farming() -> void:
	for plot in farm_tile_map.plot_coords.values():
		(plot as Plot).reset_plot()

	if year == 1:
		water = MAX_WATER
	else:
		water = MAX_WATER / 2
	print(water)
	is_harvesting = false
	is_watering = false
	is_growing = false
	is_planting = true


func _on_yam_button_pressed() -> void:
	if is_planting:
		self.is_watering = false
		current_crop = Global.Crops.YAM
		mouse_crop_sprite.visible = true
		mouse_crop_sprite.texture = mouse_crop_sprite.yam_texture


func _on_clear_button_pressed() -> void:
	current_crop = Global.Crops.EMPTY
	mouse_crop_sprite.hide()
	self.is_watering = false


func _on_next_button_pressed() -> void:
	if self.is_growing:
		self.is_growing = false
		self.is_watering = false
		mouse_crop_sprite.hide()
		for plot in farm_tile_map.plot_coords.values():
			(plot as Plot).grow_plant()

func plant_grown() -> void:
	for plot in farm_tile_map.plot_coords.values():
		if (plot as Plot).crop != Global.Crops.EMPTY and (plot as Plot).crop != Global.Crops.TREE:
			if (plot as Plot).stage < 2:
				return
	
	# All plants grown
	self.is_harvesting = true


func _on_water_button_pressed() -> void:
	if not self.is_growing or water <= 0:
		return
	self.is_watering = true
	mouse_crop_sprite.texture = mouse_crop_sprite.water_texture
	mouse_crop_sprite.show()
