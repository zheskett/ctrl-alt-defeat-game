extends Sprite2D
class_name MouseCropSprite

@export var farming_node: Farming
@export var bean_texture: Texture2D
@export var corn_texture: Texture2D
@export var casava_texture: Texture2D
@export var yam_texture: Texture2D
@export var water_texture: Texture2D
@export var watering_texture: Texture2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.position = get_global_mouse_position()
	if farming_node.is_watering:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			self.texture = watering_texture
		else:
			self.texture = water_texture
