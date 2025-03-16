extends Node2D
class_name Farming


@export var farm_tile_map: FarmTileMapLayer
@export var mouse_crop_sprite: MouseCropSprite
@export var score_label: Label
@export var water_label: Label
@export var ash_label: Label
@export var year_label: Label
@export var current_crop: Global.Crops = Global.Crops.EMPTY

var is_planting := true
var is_growing := false
var is_harvesting := false
var is_watering := false
var is_ashing := false
var planted_crops: Dictionary[Global.Crops, int] = {}

const MAX_WATER := 300
const MAX_ASH := 100
var water := 0 :
	set(value):
		water = value
		water_label.text = str(water_percent) + "%"
		if water <= 0:
			is_watering = false
			mouse_crop_sprite.hide()
var water_percent : int :
	get:
		return int((water as float) / (MAX_WATER as float) * 100.0)

var ash := 0 :
	set(value):
		ash = value
		ash_label.text = str(ash_percent) + "%"
		if water <= 0:
			is_ashing = false
			mouse_crop_sprite.hide()
var ash_percent : int :
	get:
		return int((ash as float) / (MAX_ASH as float) * 100.0)

func _ready() -> void:
	#Global.year = 1
	#Global.score = 0
	reset_farming()


func plant_planted(crop: Global.Crops) -> void:
	planted_crops.set(crop, 0)
	if planted_crops.size() >= 2:
		disable_extra_crops()
	
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
	$TopBar/BeanButton.disabled = false
	$TopBar/CornButton.disabled = false
	$TopBar/CasavaButton.disabled = false
	$TopBar/YamButton.disabled = false
	planted_crops.clear()
	score_label.text = "Score: " + str(Global.score)
	year_label.text = "Year: " + str(Global.year)
	for plot in farm_tile_map.plot_coords.values():
		(plot as Plot).reset_plot()

	if Global.year == 1:
		water = MAX_WATER
		ash = 0
	else:
		ash = MAX_ASH
		@warning_ignore("integer_division")
		water = MAX_WATER / 2

	is_harvesting = false
	is_watering = false
	is_growing = false
	is_ashing = false
	is_planting = true


func _on_clear_button_pressed() -> void:
	current_crop = Global.Crops.EMPTY
	mouse_crop_sprite.hide()
	self.is_watering = false
	self.is_ashing = false


func _on_next_button_pressed() -> void:
	if self.is_growing:
		self.is_growing = false
		self.is_watering = false
		self.is_ashing = false
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

func plant_harvested() -> void:
	score_label.text = "Score: " + str(Global.score)
	for plot in farm_tile_map.plot_coords.values():
		if (plot as Plot).crop != Global.Crops.TREE and (plot as Plot).harvested == false:
			return
	
	# All plants harvested
	self.is_harvesting = false
	Global.year += 1
	if Global.year >= 4:
		return
		#TODO end-scene

	if Global.year == 2:
		$TreeDecision.start()
		
		await Global.tree_choice
		print(Global.planted_trees)
		$TreeDecision.queue_free()
		reset_farming()
		return
	
	if Global.year == 3:
		pass

	reset_farming()

func _on_water_button_pressed() -> void:
	if not self.is_growing or water <= 0:
		return
	self.is_watering = true
	self.is_ashing = false
	mouse_crop_sprite.texture = mouse_crop_sprite.water_texture
	mouse_crop_sprite.show()

func disable_extra_crops() -> void:
	if not planted_crops.has(Global.Crops.BEAN):
		$TopBar/BeanButton.disabled = true
	if not planted_crops.has(Global.Crops.CORN):
		$TopBar/CornButton.disabled = true
	if not planted_crops.has(Global.Crops.CASAVA):
		$TopBar/CasavaButton.disabled = true
	if not planted_crops.has(Global.Crops.YAM):
		$TopBar/YamButton.disabled = true

func _on_yam_button_pressed() -> void:
	if is_planting:
		self.is_watering = false
		self.is_ashing = false
		current_crop = Global.Crops.YAM
		mouse_crop_sprite.visible = true
		mouse_crop_sprite.texture = mouse_crop_sprite.yam_texture

func _on_casava_button_pressed() -> void:
	if is_planting:
		self.is_watering = false
		self.is_ashing = false
		current_crop = Global.Crops.CASAVA
		mouse_crop_sprite.visible = true
		mouse_crop_sprite.texture = mouse_crop_sprite.casava_texture


func _on_corn_button_pressed() -> void:
	if is_planting:
		self.is_watering = false
		self.is_ashing = false
		current_crop = Global.Crops.CORN
		mouse_crop_sprite.visible = true
		mouse_crop_sprite.texture = mouse_crop_sprite.corn_texture


func _on_bean_button_pressed() -> void:
	if is_planting:
		self.is_watering = false
		self.is_ashing = false
		current_crop = Global.Crops.BEAN
		mouse_crop_sprite.visible = true
		mouse_crop_sprite.texture = mouse_crop_sprite.bean_texture


func _on_ash_button_pressed() -> void:
	if not self.is_growing or ash <= 0:
		return
	self.is_ashing = true
	self.is_watering = false
	mouse_crop_sprite.texture = mouse_crop_sprite.ash_texture
	mouse_crop_sprite.show()
