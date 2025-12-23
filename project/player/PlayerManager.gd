class_name PlayerManager extends Node

signal possessed(pawn: Pawn2D)
signal unpossessed
signal spawned(player: PlayerData)
signal despawned

var _player_scene = preload("res://player/player.tscn")
var _player_node: Player

var local_player_data: PlayerData

@export var _local_player_controller: PlayerController
@export var _player_world: World


func spawn_local_player() -> Pawn2D:
	if local_player_data == null:
		Log.err("No local player data to spawn player from")
		return null

	var pawn = spawn_player(local_player_data)
	possess_player(pawn)

	Log.pr("Local player %s spawned and possessed" % local_player_data.metadata.name)
	return pawn


func save_local_player() -> void:
	if _player_node == null:
		Log.warn("No local player to save")
		return

	var saved_data = _player_node.save_to_data()
	PlayerSaveFileAccess.save(saved_data.metadata.name, saved_data)
	Log.info("Local player %s saved" % saved_data.metadata.name)


func spawn_player(player: PlayerData) -> Pawn2D:
	_player_node = _player_scene.instantiate()
	_player_node.data = player

	if _player_world:
		_player_world.entities.add_child(_player_node)
	else:
		Log.warn("No world node set, spawning as child of self")
		add_child(_player_node)

	spawned.emit(player)

	_player_node.dropped_item.connect(_on_player_dropped_item)

	return _player_node


func despawn_player() -> void:
	if _player_node:
		_player_node.dropped_item.disconnect(_on_player_dropped_item)
		_player_node.queue_free()
		_player_node = null
		despawned.emit()


func possess_player(pawn: Pawn2D) -> void:
	Log.info("Player possessed %s" % pawn)
	_local_player_controller.possessed_pawn = pawn
	possessed.emit(pawn)


func unpossess_player() -> void:
	Log.info("Player unpossessed")
	_local_player_controller.possessed_pawn = null
	unpossessed.emit()


func _on_player_dropped_item(item: ItemData, count: int) -> void:
	ItemSpawner.spawn_item(item, count, _player_world.pickups, _player_node.global_position)
