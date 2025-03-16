extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	bug()

func bug() -> void:
	self.show()
	self.position.x = -900
	self.position.y = randi_range(-200,1800)
	print(position.y)
