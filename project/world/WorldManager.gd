class_name WorldManager extends MultiplayerSpawner

@export var _world_scene: PackedScene

var data: SaveData
var world_node: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_function = _spawn

	spawned.connect(_on_world_spawned)

	Lobby.player_connected.connect(_on_player_connected)

	add_spawnable_scene(_world_scene.resource_path)


func save() -> void:
	if world_node == null:
		Log.warn("No world to save")
		return

	if world_node.has_method("save"):
		var data_to_save: SaveData = world_node.save()
		SaveFileAccess.save(data_to_save)
		Log.info("World %s saved" % data_to_save.metadata.name)
	else:
		(
			Log
			. warn(
				"World node does not support saving. To implement, add a 'save' method returning SaveData to the world node."
			)
		)


func despawn() -> void:
	if world_node == null:
		return

	Log.info("Despawning world node: %s" % world_node)
	world_node.queue_free()
	world_node = null


func _spawn(_data) -> Node:
	Log.debug("Instantiating world")
	var node = _world_scene.instantiate()

	Log.debug("Setting world data: %s" % data)
	node.data = data

	if is_multiplayer_authority():
		Log.debug("World spawned on server")
		world_node = node
	else:
		Log.debug("World spawned on client")

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
