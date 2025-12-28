class_name PlayerManager extends Node

var _player_scene = preload("res://player/player.tscn")
var _player_node: Player

@export var _player_spawner: MultiplayerSpawner
@export var _player_world: World

# todo move this to some otehr node, make this script a dedicated Player Spawner
var character_data: PlayerData


func _ready() -> void:
	_defer_ready.call_deferred()

	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)


func _defer_ready() -> void:
	_player_spawner.spawn_path = _player_world.entities.get_path()


func despawn(id: int) -> void:
	var player = _player_world.entities.get_node("Player_%d" % id)

	if player:
		Log.info("Despawning player with ID %d" % [id])
		player.queue_free()
	else:
		Log.warn("Failed to despawn: player with ID %d not found" % [id])


func save() -> void:
	if _player_node == null:
		Log.warn("No local player to save")
		return

	if not _player_node.is_multiplayer_authority():
		return

	var saved_data = _player_node.save_to_data()
	PlayerSaveFileAccess.save(saved_data.metadata.name, saved_data)
	Log.info("Local player %s saved" % saved_data.metadata.name)


func spawn(id: int) -> Player:
	var player_node: Player = _player_scene.instantiate()
	var node_name = "Player_%d" % id

	player_node.name = node_name

	if _player_world:
		_player_world.entities.add_child(player_node, true)
	else:
		Log.warn("No world node set, spawning as child of self")
		add_child(player_node, true)

	if id == multiplayer.get_unique_id():
		Log.info("Spawning local player with ID %d" % id)
		_player_node = player_node
	else:
		Log.info("Spawning remote player with ID %d" % id)

	return player_node


#region Signals
func _on_player_connected(id: int, _info: Lobby.PlayerInfo) -> void:
	if not multiplayer.is_server():
		return

	spawn(id)


func _on_player_disconnected(id: int, _info: Lobby.PlayerInfo) -> void:
	if not multiplayer.is_server():
		return

	despawn(id)

#endregion Signals
