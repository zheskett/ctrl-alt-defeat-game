extends Area2D
class_name Plot

@export var sprite : Sprite2D
@export var empty_texture: Texture2D
@export var filled_texture: Texture2D

var farming_node : Farming

func _mouse_enter() -> void:
	pass

func _mouse_exit() -> void:
	pass

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		self.plant()

func register_farm(farm: Farming) -> void:
	farming_node = farm

func plant() -> void:
	sprite.texture = filled_texture
