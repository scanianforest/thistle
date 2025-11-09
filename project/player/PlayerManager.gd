class_name PlayerManager extends Node

var _player_scene = preload("res://player/player.tscn")
var _player_node: CharacterBody2D

var local_player_data: PlayerData

@export var _local_player_controller: PlayerController
@export var _player_node_parent: Node


func spawn_local_player(player_name: String) -> Pawn2D:
	var player_data = PlayerSaveFileAccess.load(player_name)
	if player_data == null:
		Log.info("No saved player found with name: %s, creating new player data" % player_name)
		player_data = PlayerData.new()
		player_data.metadata.name = player_name

	var pawn = _spawn_player(player_data)
	_possess_player(pawn)

	Log.pr("Local player %s spawned and possessed" % player_name)
	return pawn


func save_local_player() -> void:
	if _player_node == null:
		Log.warn("No local player to save")
		return

	var player_data = _player_node.data
	PlayerSaveFileAccess.save(player_data.metadata.name, player_data)
	Log.info("Local player %s saved" % player_data.metadata.name)


func _spawn_player(player: PlayerData) -> Pawn2D:
	_player_node = _player_scene.instantiate()
	_player_node.data = player

	if _player_node_parent:
		_player_node_parent.add_child(_player_node)
	else:
		Log.warn("No parent node set, spawning as child of self")
		add_child(_player_node)

	return _player_node


func _possess_player(pawn: Pawn2D) -> void:
	Log.info("Player possessed %s" % pawn)
	_local_player_controller.possessed_pawn = pawn


func _on_player_spawned(player: PlayerData) -> void:
	_spawn_player(player)


func _on_player_despawned() -> void:
	if _player_node and _player_node.is_inside_tree():
		_player_node.queue_free()
		_player_node = null


func _on_player_possessed(pawn: Pawn2D) -> void:
	_possess_player(pawn)


func _on_player_unpossessed() -> void:
	Log.info("Player unpossessed")
	_local_player_controller.possessed_pawn = null
