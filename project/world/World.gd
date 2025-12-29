class_name World extends Node2D

@onready var ground: Terrain = %Ground
@onready var entity_manager: EntityManager = %EntityManager
@onready var pickup_manager: PickupManager = %PickupManager

var data: WorldData = WorldData.new():
	set(value):
		data = value
		if not data:
			return

		Log.info("Setting ground tiles")
		for coord_string in data.ground_tiles.keys():
			var tile = data.ground_tiles[coord_string]
			var coord: PackedStringArray = coord_string.split(",")
			var x = int(coord[0])
			var y = int(coord[1])
			ground.draw_cell(Vector2i(x, y), tile)

		entity_manager.load(data.entities)
		pickup_manager.load(data.pickups)


func _ready() -> void:
	ground.tile_changed.connect(_on_ground_tile_changed)
	clear()


func clear() -> void:
	ground.clear_terrain()
	entity_manager.clear()
	#pickup_manager.clear()


func unload() -> void:
	data = null
	hide()
	pause()
	clear()


func create_new(world_name: String) -> void:
	data = WorldData.new()
	data.metadata.name = world_name
	Log.info("World %s created." % world_name)
	Log.debug(data.to_dict())


func load(world_name: String) -> void:
	var loaded_data = WorldSaveFileAccess.load(world_name)
	if loaded_data != null:
		data = loaded_data
		Log.info("World %s loaded." % world_name)
		Log.debug(data.to_dict())
	else:
		Log.err("No saved world found with name: ", world_name)


func save() -> void:
	if not is_multiplayer_authority():
		Log.warn("%d is not authority, skipping world save" % multiplayer.get_unique_id())
		return

	if data == null:
		Log.warn("No world data to save")
		return

	pickup_manager.save(data)
	entity_manager.save(data)

	WorldSaveFileAccess.save(data.metadata.name, data)
	Log.info("World %s saved." % data.metadata.name)
	Log.debug(data.to_dict())


func pause() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func unpause() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


func _on_ground_tile_changed(x: int, y: int, new_tile: int) -> void:
	var coord = "%d,%d" % [x, y]
	data.ground_tiles[coord] = new_tile
	Log.debug("Ground tile changed at ", coord, " to ", new_tile)
