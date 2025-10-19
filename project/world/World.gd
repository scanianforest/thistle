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

func _ready() -> void:
	GameChannel.starting.connect(_on_game_starting)
	GameChannel.started.connect(_on_game_started)
	GameChannel.joined.connect(_on_game_joined)
	GameChannel.joining.connect(_on_game_joining)
	GameChannel.saving.connect(_on_game_saving)

	ground.tile_changed.connect(_on_ground_tile_changed)

func _on_game_starting(game_data: GameData) -> void:
	self.data = game_data.world_data

func _on_game_started() -> void:
	show()
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
