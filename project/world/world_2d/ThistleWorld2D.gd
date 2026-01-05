class_name ThistleWorld2D extends Node2D

signal finished_loading

@onready var terrains: Array[Terrain]

@onready var entity_manager: EntityManager = %EntityManager
@onready var pickup_manager: PickupManager = %PickupManager

var data: WorldData

static var COMMANDS_LOADED: bool = false


func _enter_tree() -> void:
	if not COMMANDS_LOADED:
		_register_console_commands()
		COMMANDS_LOADED = true


func _ready() -> void:
	for child in $Terrain.get_children():
		terrains.push_back(child)

	clear()

	show()
	unpause()
	for terrain in terrains:
		terrain._changed()

	finished_loading.emit()


func clear() -> void:
	entity_manager.clear()
	#pickup_manager.clear()


func load() -> void:
	if not data:
		Log.err("No world data set to load from")
		return

	for coord_string in data.ground_tiles.keys():
		var tile = data.ground_tiles[coord_string]
		var coord: PackedStringArray = coord_string.split(",")
		var x = int(coord[0])
		var y = int(coord[1])
#		grass.draw_cell(Vector2i(x, y), tile)

		entity_manager.load(data.entities)
		pickup_manager.load(data.pickups)

	show()
	unpause()


func unload() -> void:
	hide()
	pause()
	clear()


func save() -> SaveData:
	if not is_multiplayer_authority():
		Log.warn("%d is not authority, skipping world save" % multiplayer.get_unique_id())
		return

	if data == null:
		Log.warn("No world data to save")
		return

	pickup_manager.save(data)
	entity_manager.save(data)

	return data


func pause() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func unpause() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


func _register_console_commands() -> void:
	LimboConsole.register_command(unload, "world_unload", "Unloads the current world.")
	LimboConsole.register_command(load, "world_load", "Loads the world from set world data.")
	LimboConsole.register_command(save, "world_save", "Saves the current world.")


func _on_entity_entered_tree(entity: Node) -> void:
	if entity.has_signal("dropped_item"):
		entity.dropped_item.connect(
			func(item: ItemData, count: int) -> void:
				pickup_manager.spawn_from_item_data(item, count, entity.global_position)
		)


func _on_ground_tile_changed(x: int, y: int, new_tile: int) -> void:
	var coord = "%d,%d" % [x, y]
	data.ground_tiles[coord] = new_tile
	Log.debug("Ground tile changed at ", coord, " to ", new_tile)
