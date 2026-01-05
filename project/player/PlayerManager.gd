class_name PlayerManager extends MultiplayerSpawner

@export var _player_scene: PackedScene

var _player_node: Node

# TODO generalize this, put elsewhere? Not all games will have character data in the player manager.
var character_data: SaveData:
	get:
		return character_data
	set(value):
		character_data = value


func _ready() -> void:
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)
	Lobby.server_disconnected.connect(_on_server_disconnected)

	spawn_function = _spawn
	spawned.connect(_on_player_spawned)
	add_spawnable_scene(_player_scene.resource_path)


func despawn_all() -> void:
	var players = get_node(spawn_path).get_children()

	for player in players:
		Log.info("Despawning player with name %s" % player.name)
		player.queue_free()


func despawn(id: int) -> void:
	if not multiplayer.is_server():
		return

	var player = get_node(spawn_path).get_node("Player_%d" % id)

	if player:
		Log.info("Despawning player with ID %d" % [id])
		player.queue_free()
	else:
		Log.warn("Failed to despawn: player with ID %d not found" % [id])


func save() -> void:
	if not _player_node:
		Log.warn("[%s] No local player to save" % multiplayer.get_unique_id())
		return

	if _player_node.has_method("save"):
		var data_to_save = _player_node.save()
		SaveFileAccess.save(data_to_save)
		Log.info("Local player %s saved" % data_to_save.metadata.name)
	else:
		(
			Log
			. warn(
				(
					"[%s] Local player node %s does not support saving. To implement, add a 'save' method returning SaveData to the player node."
					% [multiplayer.get_unique_id(), _player_node.name]
				)
			)
		)


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
	despawn(id)


# NOTE: this is called for all clients
func _on_player_spawned(player: Node) -> void:
	if player.is_multiplayer_authority():
		_player_node = player
		_player_node.data = character_data
		$PlayerInput.input_event.connect(_player_node.handle_input)

		Log.info("Local player spawned with name %s" % player.name)
		Log.debug(character_data.to_dict())
	else:
		Log.info("Remote player spawned with name %s" % player.name)

	Log.debug(player.position)


func _on_server_disconnected() -> void:
	Log.warn("Disconnected from server, performing emergency save.")
	save()
	# NOTE: this flow is a bit awkward, since the stopping of game also prompts a save.
	# At that point however, the player node is already despawned, and the method will throw a warning.
	# Keeping it like this for now, but may want to refactor later.

#endregion Signals
