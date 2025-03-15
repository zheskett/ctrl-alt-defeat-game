extends Sprite2D
class_name MouseCropSprite

@export var cabbage_texture : Texture2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = get_global_mouse_position()
