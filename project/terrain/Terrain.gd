@tool
class_name Terrain extends TileMapDual

signal tile_changed(x: int, y: int, new_tile: int)

func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		return

	WorldChannel.ground_tile_changed.connect(_on_ground_tile_changed)
	WorldChannel.grass_requested.connect(_on_grass_requested)
	WorldChannel.dirt_requested.connect(_on_dirt_requested)

func _on_ground_tile_changed(x: int, y: int, new_tile: int) -> void:
	var coord = Vector2i(x, y)	

	var current_cell = get_cell_tile_data(coord)

	if not current_cell or current_cell.terrain != new_tile: 
		draw_cell(coord, new_tile)
		tile_changed.emit(x, y, new_tile)

func _on_grass_requested(at_global_position: Vector2) -> void:
	var coord = local_to_map(at_global_position)
	WorldChannel.change_ground_tile(coord.x, coord.y, 1)

func _on_dirt_requested(at_global_position: Vector2) -> void:
	var coord = local_to_map(at_global_position)
	WorldChannel.change_ground_tile(coord.x, coord.y, 0)