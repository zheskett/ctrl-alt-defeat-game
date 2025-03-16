extends Area2D
class_name Plot

@export var ray_cast: RayCast2D
@export var animation_player: AnimationPlayer
@export var timer: Timer

@export_category("Textures")
@export var sprite: Sprite2D
@export var empty_texture: Texture2D
@export var texture_array: Array[Array]

@export_category("State")
@export var crop: Global.Crops = Global.Crops.EMPTY

const GROW_TIME = 2.0
const GROW_VARIATION = 0.7

const WATER_DICT: Dictionary[Global.Crops, int] = {
	Global.Crops.BEAN: 13,
	Global.Crops.CORN: 13,
	Global.Crops.CASAVA: 5,
	Global.Crops.YAM: 8
}

const MILD_VALUE_DICT: Dictionary[Global.Crops, int] = {
	Global.Crops.BEAN: 4,
	Global.Crops.CORN: 5,
	Global.Crops.CASAVA: 2,
	Global.Crops.YAM: 3
}

const FLOOD_VALUE_DICT: Dictionary[Global.Crops, int] = {
	Global.Crops.BEAN: 5,
	Global.Crops.CORN: 3,
	Global.Crops.CASAVA: 5,
	Global.Crops.YAM: 3
}

const DROUGHT_VALUE_DICT: Dictionary[Global.Crops, int] = {
	Global.Crops.BEAN: 3,
	Global.Crops.CORN: 0,
	Global.Crops.CASAVA: 5,
	Global.Crops.YAM: 4
}

const ASH_MILD_VALUE_DICT: Dictionary[Global.Crops, int] = {
	Global.Crops.BEAN: 0,
	Global.Crops.CORN: 2,
	Global.Crops.CASAVA: 2,
	Global.Crops.YAM: 2,
}

const ASH_FLOOD_VALUE_DICT: Dictionary[Global.Crops, int] = {
	Global.Crops.BEAN: 0,
	Global.Crops.CORN: 0,
	Global.Crops.CASAVA: 0,
	Global.Crops.YAM: 0,
}

const ASH_DROUGHT_VALUE_DICT: Dictionary[Global.Crops, int] = {
	Global.Crops.BEAN: 2,
	Global.Crops.CORN: 1,
	Global.Crops.CASAVA: 1,
	Global.Crops.YAM: 2,
}

const TREE_MILD_VALUE_DICT: Dictionary[Global.Crops, int] = {
	Global.Crops.BEAN: 0,
	Global.Crops.CORN: 0,
	Global.Crops.CASAVA: 0,
	Global.Crops.YAM: 0,
}

const TREE_FLOOD_VALUE_DICT: Dictionary[Global.Crops, int] = {
	Global.Crops.BEAN: 1,
	Global.Crops.CORN: 1,
	Global.Crops.CASAVA: 1,
	Global.Crops.YAM: 2,
}

const TREE_DROUGHT_VALUE_DICT: Dictionary[Global.Crops, int] = {
	Global.Crops.BEAN: 0,
	Global.Crops.CORN: 0,
	Global.Crops.CASAVA: 0,
	Global.Crops.YAM: 0,
}

const ASH_COST = 10
const ASH_RANGE = 2

var can_be_tree := false
var farming_node: Farming
var harvested := true
var stage := 0
var water := 0
var ash := 0
var water_needed := 0
var ash_needed := 0
var mouse_in := false

# Handle watering
func _mouse_enter() -> void:
	mouse_in = true

func _mouse_exit() -> void:
	mouse_in = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		self.plant_clicked()

func register_farm(farm: Farming) -> void:
	farming_node = farm

func reset_plot() -> void:
	$WaterParticles.emitting = false
	$AshParticles.emitting = false
	if can_be_tree and Global.planted_trees:
		self.crop = Global.Crops.TREE
		harvested = false
		sprite.texture = texture_array[Global.Crops.TREE - 1][0]
	else:
		harvested = true
		self.crop = Global.Crops.EMPTY
		sprite.texture = empty_texture


func grow_plant() -> void:
	if not (self.crop != Global.Crops.EMPTY and self.crop != Global.Crops.TREE and self.harvested == false):
		return
	
	stage = 0
	for _i in range(2):
		timer.start(GROW_TIME + randf_range(-GROW_VARIATION, GROW_VARIATION))
		
		await timer.timeout
		stage += 1
		sprite.texture = texture_array[self.crop - 1][stage]
		animation_player.play("grow")
		if stage == 2:
			farming_node.plant_grown()

func flood_plant() -> void:
	if not (self.crop != Global.Crops.EMPTY and self.crop != Global.Crops.TREE and self.harvested == false and self.stage >= 2):
		return
	
	# TODO change texture

func _harvest_plant() -> void:
	$WaterParticles.emitting = false
	$AshParticles.emitting = false
	var num_same := 0
	var num_diff := 0
	var score := 1
	for _dir in range(4):
		ray_cast.force_raycast_update()
		var ray_hit := ray_cast.get_collider()
		if ray_hit != null and ray_hit is Plot:
			var ray_plot: Plot = ray_hit as Plot
			if ray_plot.crop != Global.Crops.EMPTY:
				if ray_plot.crop == self.crop:
					num_same += 1
				else:
					num_diff += 1
			
		ray_cast.rotate(deg_to_rad(90.0))

	# Multicrop score calculation
	score += mini(2, num_diff) - maxi(0, num_diff - 2)
	score += mini(2, num_same) - maxi(0, num_same - 2)
	
	# Check if watered
	score += 2 if water >= water_needed else -1
	
	# TODO Check weather
	if Global.weather == Global.Weathers.TEMPERATE:
		score += MILD_VALUE_DICT.get(crop, 0)
		score += ASH_MILD_VALUE_DICT.get(crop, 0) if ash >= ash_needed else 0
		score += TREE_MILD_VALUE_DICT.get(crop, 0) if Global.planted_trees else 0
	elif Global.weather == Global.Weathers.FLOOD:
		score += FLOOD_VALUE_DICT.get(crop, 0)
		score += ASH_FLOOD_VALUE_DICT.get(crop, 0) if ash >= ash_needed else 0
		score += TREE_FLOOD_VALUE_DICT.get(crop, 0) if Global.planted_trees else -2
	elif Global.weather == Global.Weathers.DROUGHT:
		score += DROUGHT_VALUE_DICT.get(crop, 0)
		score += ASH_DROUGHT_VALUE_DICT.get(crop, 0) if ash >= ash_needed else 0
		score += TREE_DROUGHT_VALUE_DICT.get(crop, 0) if Global.planted_trees else 0
	
	# Random score change
	# score += randi_range(-1, 1)
	score = maxi(0, score)
	
	# Play harvest animation
	self.harvested = true
	sprite.texture = empty_texture
	Global.score += score
	$ScoreLabel.text = "+" + str(score)
	water = 0
	water_needed = 0
	ash = 0
	ash_needed = 0
	animation_player.play("harvest")
	farming_node.plant_harvested()

func plant_clicked() -> void:
	if farming_node.is_harvesting and self.crop != Global.Crops.EMPTY and self.crop != Global.Crops.TREE and not self.harvested:
		_harvest_plant()


	elif farming_node.is_planting:
		if self.crop != Global.Crops.EMPTY or farming_node.current_crop == Global.Crops.EMPTY:
			return
		
		self.harvested = false
		self.crop = farming_node.current_crop
		stage = 0
		sprite.texture = texture_array[self.crop - 1][stage]
		self.water = 0
		self.water_needed = WATER_DICT.get(self.crop, 1)
		self.ash = 0
		self.ash_needed = ASH_COST + randi_range(-ASH_RANGE, ASH_RANGE)
		
		animation_player.play("plant_crop")
		farming_node.plant_planted(self.crop)

func _physics_process(_delta: float) -> void:
	if not self.mouse_in or not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	if farming_node.is_watering and self.water < self.water_needed and self.crop != Global.Crops.EMPTY and self.crop != Global.Crops.TREE:
		water += 1
		farming_node.water -= 1
		if water >= water_needed:
			$WaterParticles.emitting = true

	if farming_node.is_ashing and self.ash < self.ash_needed and self.crop != Global.Crops.EMPTY and self.crop != Global.Crops.TREE:
		ash += 1
		farming_node.ash -= 1
		if ash >= ash_needed:
			$AshParticles.emitting = true
