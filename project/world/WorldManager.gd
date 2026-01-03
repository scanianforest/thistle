class_name WorldManager extends MultiplayerSpawner

signal world_ready

@export var _world_scene: PackedScene

var data: SaveData
var world_node: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_function = _spawn

	spawned.connect(_on_world_spawned)

	Lobby.player_connected.connect(_on_player_connected)

	add_spawnable_scene(_world_scene.resource_path)


func _spawn(_data) -> Node:
	Log.debug("Instantiating world")
	var node = _world_scene.instantiate()

	Log.debug("Setting world data: %s" % data)
	node.data = data

	Log.debug("Spawning world node: %s" % node)
	return node


func _on_world_spawned(node: Node) -> void:
	Log.debug("World spawned: %s" % node)
	if node.is_multiplayer_authority():
		Log.debug("Spawning local world")
	else:
		Log.debug("Spawned remote world")

	world_node = node


func _on_player_connected(_id: int, _info: Lobby.PlayerInfo) -> void:
	if not multiplayer.is_server():
		return

	if world_node != null:
		return

	var spawned_world = spawn(null)
	_on_world_spawned(spawned_world)
