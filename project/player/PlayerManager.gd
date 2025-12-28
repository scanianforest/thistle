class_name PlayerManager extends Node

var _player_scene = preload("res://player/player.tscn")
var _player_node: Player

var local_player_data: PlayerData

@export var _player_spawner: MultiplayerSpawner
@export var _player_world: World


func _ready() -> void:
	_defer_ready.call_deferred()

	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)


func _defer_ready() -> void:
	_player_spawner.spawn_path = _player_world.entities.get_path()


func spawn(id: int, _info: Lobby.PlayerInfo) -> Player:
	if local_player_data == null:
		Log.err("No local player data to spawn player from")
		return null

	var player: Player = _spawn_player(id, PlayerData.new())

	player.dropped_item.connect(_on_player_dropped_item)

	return player


func despawn(id: int) -> void:
	var player = _player_world.entities.get_node("Player_%d" % id)
	Log.pr("Despawning player with ID %d: %s" % [id, player])

	if player:
		player.queue_free()


func save() -> void:
	if not is_multiplayer_authority():
		return

	if _player_node == null:
		Log.warn("No local player to save")
		return

	var saved_data = _player_node.save_to_data()
	PlayerSaveFileAccess.save(saved_data.metadata.name, saved_data)
	Log.info("Local player %s saved" % saved_data.metadata.name)


func _spawn_player(id: int, player_data: PlayerData) -> Player:
	var player_node: Player = _player_scene.instantiate()
	var node_name = "Player_%d" % id

	player_node.name = node_name
	#player_node.data = player_data

	if _player_world:
		_player_world.entities.add_child(player_node, true)
	else:
		Log.warn("No world node set, spawning as child of self")
		add_child(player_node, true)

	return player_node


func _on_player_dropped_item(item: ItemData, count: int) -> void:
	var pickup: ItemPickupData = ItemPickupData.new()
	pickup.item = item
	pickup.position = _player_node.global_position
	if multiplayer.is_server():
		_player_world.pickups.spawn_item_pickup(pickup)
	else:
		_player_world.pickups.rpc_spawn_item_pickup.rpc_id(1, pickup.to_dict())


#region Signals
func _on_player_connected(id: int, info: Lobby.PlayerInfo) -> void:
	if not multiplayer.is_server():
		return
	Log.pr("PlayerManager detected player connected with ID %d and name %s" % [id, info.name])
	spawn(id, info)


func _on_player_disconnected(id: int, info: Lobby.PlayerInfo) -> void:
	if not multiplayer.is_server():
		return
	Log.pr("PlayerManager detected player disconnected with ID %d and name %s" % [id, info.name])
	despawn(id)

#endregion Signals
