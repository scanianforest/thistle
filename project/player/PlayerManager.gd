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

@onready var nid = multiplayer.get_unique_id()


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


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


@rpc("any_peer", "call_remote")
func _spawn_player_rpc(player_data: Dictionary, id: int) -> Pawn2D:
	var player = PlayerData.from_dict(player_data)
	return spawn_player(player, id)


func spawn_player(player: PlayerData, network_id: int = 1) -> Pawn2D:
	_player_node = _player_scene.instantiate()
	_player_node.name = "Player_%s_%s" % [player.name, network_id]
	_player_node.data = player
	_player_node.set_multiplayer_authority(network_id)

	if _player_world:
		_player_world.entities.add_child(_player_node, true)
	else:
		Log.warn("No world node set, spawning as child of self")
		add_child(_player_node)

	spawned.emit(player)

	_player_node.dropped_item.connect(_on_player_dropped_item)

	return _player_node


func _on_peer_connected(id: int) -> void:
	Log.pr("Peer connected with ID: %d" % id)
	_spawn_player_rpc.rpc(local_player_data.to_dict(), id)


func _on_peer_disconnected(id: int) -> void:
	Log.pr("Peer disconnected with ID: %d" % id)
	despawn_remote_player.rpc(id)


func despawn_player() -> void:
	if _player_node:
		_player_node.dropped_item.disconnect(_on_player_dropped_item)
		_player_node.queue_free()
		_player_node = null
		despawned.emit()


@rpc("any_peer", "call_remote")
func despawn_remote_player(id: int) -> void:
	for child in _player_world.entities.get_children():
		if child is Player and child.get_multiplayer_authority() == id:
			child.queue_free()
			despawned.emit()
			return


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
