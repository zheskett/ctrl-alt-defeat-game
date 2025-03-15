extends Area2D
class_name Plot

@export var ray_cast: RayCast2D
@export var animation_player: AnimationPlayer

@export_subgroup("Textures")
@export var sprite: Sprite2D
@export var empty_texture: Texture2D
@export var filled_texture: Texture2D

@export_subgroup("State")
@export var crop: Global.Crops = Global.Crops.EMPTY

var farming_node: Farming
var harvested := true

func _mouse_enter() -> void:
	pass

func _mouse_exit() -> void:
	pass

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		self.plant_clicked()

func register_farm(farm: Farming) -> void:
	farming_node = farm

func reset_plot() -> void:
	harvested = true
	self.crop = Global.Crops.EMPTY
	sprite.texture = empty_texture

func plant_clicked() -> void:
	if farming_node.is_harvesting and self.crop != Global.Crops.EMPTY:
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
		
		# TODO Check weather
		
		# Random score change
		score += randi_range(-1, 1)
		score = maxi(0, score)
		
		# Play harvest animation
		self.harvested = true
		sprite.texture = empty_texture
		farming_node.score += score
		$ScoreLabel.text = "+" + str(score)
		animation_player.play("harvest")


	elif farming_node.is_planting:
		if self.crop != Global.Crops.EMPTY and farming_node.current_crop != Global.Crops.EMPTY:
			return
		
		
		self.harvested = false
		self.crop = farming_node.current_crop
		if farming_node.current_crop == Global.Crops.YAM:
			sprite.texture = filled_texture
		
		animation_player.play("plant_crop")
