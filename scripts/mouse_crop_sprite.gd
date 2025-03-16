extends Sprite2D
class_name MouseCropSprite

@export var farming_node: Farming
@export var bean_texture: Texture2D
@export var corn_texture: Texture2D
@export var casava_texture: Texture2D
@export var yam_texture: Texture2D
@export var water_texture: Texture2D
@export var watering_texture: Texture2D
@export var ash_texture: Texture2D
@export var harvest_texture: Texture2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not farming_node.is_ashing:
		$CPUParticles2D.emitting = false
	if not farming_node.is_watering and $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "water":
		$AnimationPlayer.stop()
	self.position = get_global_mouse_position()
	if farming_node.is_watering:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			self.texture = watering_texture
			$AnimationPlayer.play("water")
		else:
			self.texture = water_texture
			$AnimationPlayer.pause()
	if farming_node.is_ashing:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			$CPUParticles2D.emitting = true
		else:
			$CPUParticles2D.emitting = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("click") and farming_node.is_harvesting:
		$AnimationPlayer.play("harvest")
