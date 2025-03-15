extends TileMapLayer
class_name FarmTileMapLayer

@export var farming_node : Farming

var plot_coords: Dictionary[Vector2i, Plot]

func _enter_tree() -> void:
	child_entered_tree.connect(_register_child)
	child_exiting_tree.connect(_unregister_child)

func _register_child(child: Node) -> void:
	await child.ready
	if child is not Plot:
		return

	var coords: Vector2i = local_to_map(to_local(child.global_position))
	plot_coords[coords] = child
	child.set_meta("tile_coords", coords)
	child.register_farm(farming_node)

func _unregister_child(child: Node) -> void:
	if child is not Plot:
		return

	plot_coords.erase(child.get_meta("tile_coords"))

func get_cell_scene(coords: Vector2i) -> Plot:
	return plot_coords.get(coords, null)
