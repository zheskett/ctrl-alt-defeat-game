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

const MAX_WATER := 200
const MAX_ASH := 90
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
		if ash <= 0:
			is_ashing = false
			mouse_crop_sprite.hide()
var ash_percent : int :
	get:
		return int((ash as float) / (MAX_ASH as float) * 100.0)

var infoPopup

func _ready() -> void:
	#Global.year = 1
	#Global.score = 0
	$InformationTiles.hide()
	await $DialogBox.show_dialog(3, "Hi! I see you're getting started planting crops. I recommend that you plant at least two, and try to intermix where you plant them to help the soil.")
	await $DialogBox.show_dialog(3, "I would also take advantage of the water and ash provided to hydrate and fertilize your crops. Oh, and only two crops can be planted in a field! Good luck!")

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
	
	$TopBar/NextButton.visible = true
	$TopBar/WaterButton.disabled = false
	$TopBar/AshButton.disabled = false
	$TopBar/BeanButton.disabled = true
	$TopBar/CornButton.disabled = true
	$TopBar/CasavaButton.disabled = true
	$TopBar/YamButton.disabled = true


func reset_farming() -> void:
	$TopBar/BeanButton.disabled = false
	$TopBar/CornButton.disabled = false
	$TopBar/CasavaButton.disabled = false
	$TopBar/YamButton.disabled = false
	$TopBar/WaterButton.disabled = true
	$TopBar/AshButton.disabled = true
	planted_crops.clear()
	score_label.text = "Score: " + str(Global.score)
	year_label.text = "Year: " + str(Global.year)
	for plot in farm_tile_map.plot_coords.values():
		(plot as Plot).reset_plot()

	if Global.year == 1:
		Global.weather = Global.Weathers.TEMPERATE
		water = MAX_WATER
		ash = 0
	else:
		Global.weather = randi_range(Global.Weathers.DROUGHT, Global.Weathers.FLOOD) as Global.Weathers
		ash = MAX_ASH
		@warning_ignore("integer_division")
		water = 2 * MAX_WATER / (Global.year + 1)

	is_harvesting = false
	is_watering = false
	is_growing = false
	is_ashing = false
	is_planting = true
	
	$TopBar/NextButton.visible = false


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
		$TopBar/NextButton.visible = false
		$TopBar/WaterButton.disabled = true
		$TopBar/AshButton.disabled = true
		for plot in farm_tile_map.plot_coords.values():
			(plot as Plot).grow_plant()


func plant_grown() -> void:
	for plot in farm_tile_map.plot_coords.values():
		if (plot as Plot).crop != Global.Crops.EMPTY and (plot as Plot).crop != Global.Crops.TREE:
			if (plot as Plot).stage < 2:
				return
	
	# All plants grown
	
	# Weather Event
	if Global.weather == Global.Weathers.TEMPERATE:
		await $DialogBox.show_dialog($DialogBox.genRandomPerson(), "Looks like some pretty lucky weather this year! Nothing too difficult.")
		pass
	
	elif Global.weather == Global.Weathers.DROUGHT:
		await $DialogBox.show_dialog($DialogBox.genRandomPerson(), "Looks like a drought is coming! Hopefully you watered your crops.")
		$AnimationPlayer.play("drought")
		await $AnimationPlayer.animation_finished
	
	elif Global.weather == Global.Weathers.FLOOD:
		await $DialogBox.show_dialog($DialogBox.genRandomPerson(), "Looks like a flood is coming! Hopefully you have some protection from the river.")
		$AnimationPlayer.play("flood")
		await $AnimationPlayer.animation_finished
		# Dialogue?
	
	self.is_harvesting = true
	mouse_crop_sprite.texture = mouse_crop_sprite.harvest_texture
	mouse_crop_sprite.show()

func plant_harvested() -> void:
	score_label.text = "Score: " + str(Global.score)
	for plot in farm_tile_map.plot_coords.values():
		if (plot as Plot).crop != Global.Crops.TREE and (plot as Plot).harvested == false:
			return
	
	# All plants harvested
	mouse_crop_sprite.hide()
	self.is_harvesting = false
	Global.year += 1
	if Global.year >= 4:
		$Timer.start()
		await $Timer.timeout
		get_tree().change_scene_to_file("res://scenes/transitionToEnd.tscn")


	if Global.year == 2:
		if (Global.score <= 100):

			await $DialogBox.show_dialog(0, "Hi there! I see your first season was a little rough. Try planting alternating rows of crops and be sure to water them!")
		else:
			await $DialogBox.show_dialog(0, "Hi there! I see the progress you're making. Very impressive!")
		$TreeDecision.start()
		
		await Global.tree_choice
		$TreeDecision.queue_free()
		reset_farming()
		return
	
	if Global.year == 3:
		if (Global.score > 220):
			await $DialogBox.show_dialog(2, "Hey neighbor! Seems like you're learning more and more each year. Good job!")
		else:
			await $DialogBox.show_dialog(2, "Hey neighbor! Pro tip: planting intermixed crops, watering and fertilizing before harvest really improves yield!")

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

func _on_cropinfobutton_pressed() -> void:
	$InformationTiles.show_info()
