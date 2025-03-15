extends Sprite2D
class_name MouseCropSprite

@export var yam_texture : Texture2D
@export var water_texture : Texture2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = get_global_mouse_position()
