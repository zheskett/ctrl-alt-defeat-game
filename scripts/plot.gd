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

const WATER_DICT : Dictionary[Global.Crops, int] = {
	Global.Crops.YAM: 8
}

var farming_node: Farming
var harvested := true
var stage := 0
var water := 0
var water_needed := 0
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
	harvested = true
	self.crop = Global.Crops.EMPTY
	sprite.texture = empty_texture
	$WaterParticles.emitting = false

func grow_plant() -> void:
	if not (self.crop != Global.Crops.EMPTY and self.crop != Global.Crops.TREE and self.harvested == false):
		return
	
	stage = 0
	for _i in range(2):
		timer.start(GROW_TIME + randf_range(-GROW_VARIATION, GROW_VARIATION))
		
		await timer.timeout
		stage += 1
		sprite.texture = texture_array[self.crop - 1][stage]
		if stage == 2:
			farming_node.plant_grown()

func _harvest_plant() -> void:
	$WaterParticles.emitting = false
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
	print(str(score) + ", " + str(num_diff) + ", " + str(num_same))
	score += mini(2, num_diff) - maxi(0, num_diff - 2)
	score += mini(2, num_same) - maxi(0, num_same - 2)
	
	# Check if watered
	score += 1 if water >= water_needed else -2
	
	# TODO Check weather
	
	
	# Random score change
	score += randi_range(-1, 1)
	score = maxi(0, score)
	
	# Play harvest animation
	self.harvested = true
	sprite.texture = empty_texture
	farming_node.score += score
	$ScoreLabel.text = "+" + str(score)
	water = 0
	water_needed = 0
	animation_player.play("harvest")

func plant_clicked() -> void:
	if farming_node.is_harvesting and self.crop != Global.Crops.EMPTY:
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
		
		animation_player.play("plant_crop")
		farming_node.plant_planted()

func _physics_process(_delta: float) -> void:
	if not self.mouse_in or not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	if farming_node.is_watering and self.water < self.water_needed and self.crop != Global.Crops.EMPTY:
		water += 1
		if water >= water_needed:
			$WaterParticles.emitting = true
			pass
	
	
