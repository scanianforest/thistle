class_name World extends Node2D

@onready var grass: Terrain = %Grass
@onready var entity_manager: EntityManager = %EntityManager
@onready var pickup_manager: PickupManager = %PickupManager

@onready var comp: WorldComponent = $WorldComponent

var _data: WorldData:
	get:
		return comp.data


func _enter_tree() -> void:
	_register_console_commands()


func _ready() -> void:
	grass.tile_changed.connect(_on_ground_tile_changed)
	clear()


func clear() -> void:
	grass.clear_terrain()
	entity_manager.clear()
	#pickup_manager.clear()


func load() -> void:
	if not _data:
		Log.err("No world data set to load from")
		return

	for coord_string in comp.data.ground_tiles.keys():
		var tile = _data.ground_tiles[coord_string]
		var coord: PackedStringArray = coord_string.split(",")
		var x = int(coord[0])
		var y = int(coord[1])
		grass.draw_cell(Vector2i(x, y), tile)

		entity_manager.load(_data.entities)
		pickup_manager.load(_data.pickups)

	show()
	unpause()


func unload() -> void:
	hide()
	pause()
	clear()


func save() -> void:
	if not is_multiplayer_authority():
		Log.warn("%d is not authority, skipping world save" % multiplayer.get_unique_id())
		return

	if _data == null:
		Log.warn("No world data to save")
		return

	pickup_manager.save(_data)
	entity_manager.save(_data)

	SaveFileAccess.save(_data)
	Log.info("World %s saved." % _data.metadata.name)
	Log.debug(_data.to_dict())


func pause() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func unpause() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


func _register_console_commands() -> void:
	LimboConsole.register_command(unload, "world_unload", "Unloads the current world.")
	LimboConsole.register_command(load, "world_load", "Loads the world from set world data.")
	LimboConsole.register_command(save, "world_save", "Saves the current world.")


func _on_ground_tile_changed(x: int, y: int, new_tile: int) -> void:
	var coord = "%d,%d" % [x, y]
	_data.ground_tiles[coord] = new_tile
	Log.debug("Ground tile changed at ", coord, " to ", new_tile)
