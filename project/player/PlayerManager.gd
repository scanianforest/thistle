class_name PlayerManager extends Node

var _player_scene = preload("res://player/player.tscn")
var _player_node: Player

@export var _player_spawner: MultiplayerSpawner
@export var _player_world: World

var character_data: PlayerData


func _ready() -> void:
	_defer_ready.call_deferred()

	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_server_disconnected)

	_player_spawner.spawn_function = spawn
	_player_spawner.spawned.connect(_on_player_spawned)


func _defer_ready() -> void:
	_player_spawner.spawn_path = _player_world.entity_manager.get_path()


func despawn(id: int) -> void:
	var player = _player_world.entity_manager.get_node("Player_%d" % id)

	if player:
		Log.info("Despawning player with ID %d" % [id])
		player.queue_free()
	else:
		Log.warn("Failed to despawn: player with ID %d not found" % [id])


func save(emergency: bool = false) -> void:
	if _player_node == null:
		Log.warn("No local player to save")
		return

	if not emergency and not _player_node.is_multiplayer_authority():
		return

	var saved_data = _player_node.save_to_data()
	PlayerSaveFileAccess.save(saved_data.metadata.name, saved_data)
	Log.info("Local player %s saved" % saved_data.metadata.name)


func spawn(id: int) -> Player:
	var player_node: Player = _player_scene.instantiate()
	var node_name = "Player_%d" % id

	player_node.name = node_name
	player_node.set_multiplayer_authority(id)

	return player_node


#region Signals
func _on_player_connected(id: int, _info: Lobby.PlayerInfo) -> void:
	if not multiplayer.is_server():
		return

	var player = _player_spawner.spawn(id)
	_on_player_spawned(player)


func _on_player_disconnected(id: int, _info: Lobby.PlayerInfo) -> void:
	if not multiplayer.is_server():
		return

	despawn(id)


func _on_player_spawned(player: Player) -> void:
	if player.is_multiplayer_authority():
		Log.info("Local player spawned with name %s" % player.name)
		_player_node = player
		_player_node.data = character_data
		_player_node.dropped_item.connect(_on_player_dropped_item)
	else:
		Log.info("Remote player spawned with name %s" % player.name)


func _on_server_disconnected() -> void:
	Log.err("Disconnected from server, performing emergency save...")
	save(true)


func _on_player_dropped_item(item: ItemData, count: int) -> void:
	_player_world.pickup_manager.spawn_from_item_data(item, count, _player_node.global_position)

#endregion Signals
