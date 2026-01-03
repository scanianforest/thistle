class_name PlayerManager extends MultiplayerSpawner

@export var _player_scene: PackedScene

var _player_node: Node

# TODO generalize this, put elsewhere? Not all games will have character data in the player manager.
var character_data: SaveData


func _ready() -> void:
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_server_disconnected)

	spawn_function = _spawn
	spawned.connect(_on_player_spawned)
	add_spawnable_scene(_player_scene.resource_path)


func despawn(id: int) -> void:
	var player = get_node(spawn_path).get_node("Player_%d" % id)

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

	var data_to_save = _player_node.save_to_data()
	SaveFileAccess.save(data_to_save)
	Log.info("Local player %s saved" % data_to_save.metadata.name)


func _spawn(id: int) -> Node:
	var player_node: Node = _player_scene.instantiate()
	var node_name = "Player_%d" % id

	player_node.name = node_name
	player_node.set_multiplayer_authority(id)

	return player_node


#region Signals
func _on_player_connected(id: int, _info: Lobby.PlayerInfo) -> void:
	if not multiplayer.is_server():
		return

	var player = spawn(id)
	_on_player_spawned(player)


func _on_player_disconnected(id: int, _info: Lobby.PlayerInfo) -> void:
	if not multiplayer.is_server():
		return

	despawn(id)


# NOTE: this is called for all clients
func _on_player_spawned(player: Node) -> void:
	if player.is_multiplayer_authority():
		Log.info("Local player spawned with name %s" % player.name)
		_player_node = player
		_player_node.data = character_data
	else:
		Log.info("Remote player spawned with name %s" % player.name)


func _on_server_disconnected() -> void:
	Log.err("Disconnected from server, performing emergency save...")
	save(true)

#endregion Signals
