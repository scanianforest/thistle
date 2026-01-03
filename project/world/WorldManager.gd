class_name WorldManager extends MultiplayerSpawner

@export var _world_scene: PackedScene

var data: SaveData
var world_node: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawned.connect(_on_world_spawned)

	Lobby.player_connected.connect(_on_player_connected)

	spawn_function = _spawn

	add_spawnable_scene(_world_scene.resource_path)


func _spawn() -> Node:
	if not is_multiplayer_authority():
		return

	if not data:
		Log.err("No world data to spawn from")
		return null

	Log.debug("Instantiating world")
	world_node = _world_scene.instantiate()

	Log.debug("Setting world data: %s" % data)
	world_node.data = data

	Log.debug("Spawning world node: %s" % world_node)
	return world_node


func _on_world_spawned(node: Node) -> void:
	if node.is_multiplayer_authority():
		Log.debug("Spawning local world")
	else:
		Log.debug("Spawned remote world")

	world_node = node


func _on_player_connected(id: int, _info: Lobby.PlayerInfo) -> void:
	if not multiplayer.is_server():
		return
	if world_node == null:
		Log.err("No world node to sync with new player %d" % id)
		return

	spawn()
