class_name PlayerManager extends Node

signal possessed(pawn: Pawn2D)
signal unpossessed
signal spawned(player: PlayerData)
signal despawned

var _player_scene = preload("res://player/player.tscn")
var _player_node: Player

var local_player_data: PlayerData

@export var _local_player_controller: PlayerController
@export var _player_spawner: MultiplayerSpawner
@export var _player_world: World


func _ready() -> void:
	_defer_ready.call_deferred()

	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)


func _defer_ready() -> void:
	_player_spawner.spawn_path = _player_world.entities.get_path()


func spawn(id: int, info: Lobby.PlayerInfo) -> Player:
	if local_player_data == null:
		Log.err("No local player data to spawn player from")
		return null

	var player: Player

	var uid = multiplayer.get_unique_id()
	Log.pr(uid)

	if id == multiplayer.get_unique_id():
		player = _spawn_player(local_player_data, id)
		possess_player(player)
		Log.pr("Local player %s spawned and possessed" % local_player_data.metadata.name)
	else:
		player = _spawn_player(PlayerData.new(), id)
		player.name = info.name
		Log.pr("Remote player %s spawned for id %d" % [info.name, id])

	player.dropped_item.connect(_on_player_dropped_item)

	return player


func save() -> void:
	if not is_multiplayer_authority():
		return

	if _player_node == null:
		Log.warn("No local player to save")
		return

	var saved_data = _player_node.save_to_data()
	PlayerSaveFileAccess.save(saved_data.metadata.name, saved_data)
	Log.info("Local player %s saved" % saved_data.metadata.name)


func despawn_player() -> void:
	if _player_node:
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


func _spawn_player(player: PlayerData, network_id: int = 1) -> Player:
	var player_node = _player_scene.instantiate()
	player_node.name = "Player_%s_%s" % [player.name, network_id]
	player_node.data = player
	player_node.set_multiplayer_authority(network_id)

	if _player_world:
		_player_world.entities.add_child(player_node)
	else:
		Log.warn("No world node set, spawning as child of self")
		add_child(player_node)

	spawned.emit(player)

	return player_node


func _on_player_dropped_item(item: ItemData, count: int) -> void:
	var pickup: ItemPickupData = ItemPickupData.new()
	pickup.item = item
	pickup.position = _local_player_controller.possessed_pawn.global_position
	if multiplayer.is_server():
		_player_world.pickups.spawn_item_pickup(pickup)
	else:
		_player_world.pickups.rpc_spawn_item_pickup.rpc_id(1, pickup.to_dict())


#region Signals
func _on_player_connected(id: int, info: Lobby.PlayerInfo) -> void:
	Log.pr("PlayerManager detected player connected with ID %d and name %s" % [id, info.name])
	spawn(id, info)


func _on_player_disconnected(id: int, info: Lobby.PlayerInfo) -> void:
	Log.pr("PlayerManager detected player disconnected with ID %d and name %s" % [id, info.name])

#endregion Signals
