extends Area2D
class_name Plot

@export_subgroup("Textures")
@export var sprite : Sprite2D
@export var empty_texture: Texture2D
@export var filled_texture: Texture2D

@export_subgroup("State")
@export var crop : Global.Crops = Global.Crops.EMPTY

var farming_node : Farming

func _mouse_enter() -> void:
	pass

func _mouse_exit() -> void:
	pass

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		self.plant_clicked()

func register_farm(farm: Farming) -> void:
	farming_node = farm

func plant_clicked() -> void:
	if self.crop != Global.Crops.EMPTY and farming_node.current_crop != Global.Crops.EMPTY:
		return
	
	self.crop = farming_node.current_crop
	if farming_node.current_crop == Global.Crops.CABBAGE:
		sprite.texture = filled_texture
	
