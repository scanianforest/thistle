class_name World extends Node2D

@onready var ground: Terrain = %Ground

var data: WorldData = WorldData.new():
	set(value):
		data = value
		Log.pr("Setting ground tiles")
		for coord_string in data.ground_tiles.keys():
			var tile = data.ground_tiles[coord_string]
			var coord: PackedStringArray = coord_string.split(",")
			var x = int(coord[0])
			var y = int(coord[1])
			ground.draw_cell(Vector2i(x, y), tile)


static func exists(world_name: String) -> bool:
	return WorldSaveFileAccess.exists(world_name)


static func create_world(world_name: String) -> WorldData:
	var new_world_data = WorldData.new()
	new_world_data.metadata.name = world_name
	return new_world_data


static func load_existing_world(world_name: String) -> WorldData:
	var loaded_data = WorldSaveFileAccess.load_world_data(world_name)
	if loaded_data != null:
		return loaded_data
	else:
		Log.pr("No saved world found with name: ", world_name)
		return null


func _ready() -> void:
	GameChannel.joined.connect(_on_game_joined)
	GameChannel.joining.connect(_on_game_joining)

	ground.tile_changed.connect(_on_ground_tile_changed)


func start_new(world_name: String) -> void:
	data = WorldData.new()
	data.metadata.name = world_name
	Log.pr("New world started: ", data.to_dict())


func load_existing(world_name: String) -> void:
	var loaded_data = WorldSaveFileAccess.load_world_data(world_name)
	if loaded_data != null:
		data = loaded_data
		Log.pr("World loaded: ", data.to_dict())
	else:
		Log.pr("No saved world found with name: ", world_name)


func save() -> void:
	WorldSaveFileAccess.save(data.metadata.name, data)
	Log.pr("World saved: ", data.to_dict())


func pause() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func unpause() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


func _on_game_joined() -> void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT


func _on_game_joining(_game_data: GameData) -> void:
	Log.pr("TODO implement joining logic")


func _on_game_saving(game_data: GameData) -> void:
	Log.pr("Storing world data: ", self.data.to_dict())
	game_data.world_data = self.data


func _on_ground_tile_changed(x: int, y: int, new_tile: int) -> void:
	var coord = "%d,%d" % [x, y]
	data.ground_tiles[coord] = new_tile
	Log.pr("Ground tile changed at ", coord, " to ", new_tile)
