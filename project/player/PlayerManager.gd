extends Node

var _player_scene = preload("res://player/Player.tscn")
var _player_node: CharacterBody2D

@export var _local_player_controller: PlayerController
@export var _player_node_parent: Node


func _ready() -> void:
	PlayerChannel.spawned.connect(_on_player_spawned)
	PlayerChannel.despawned.connect(_on_player_despawned)
	PlayerChannel.possessed.connect(_on_player_possessed)
	PlayerChannel.unpossessed.connect(_on_player_unpossessed)

	PlayerChannel.spawn(Vector2.ZERO) # Initial spawn at origin for testing
	_player_node.possess() # DEBUG: Automatically possess the player on spawn

func _on_player_spawned(global_position: Vector2) -> CharacterBody2D:
	_player_node = _player_scene.instantiate()
	_player_node.global_position = global_position # Use global_position for consistency
	
	if _player_node_parent:
		_player_node_parent.add_child(_player_node)
	else:
		Log.warn("No parent node set, spawning as child of self")
		add_child(_player_node)
	
	return _player_node

func _on_player_despawned() -> void:
	if _player_node and _player_node.is_inside_tree():
		_player_node.queue_free()
		_player_node = null

func _on_player_possessed(pawn: Pawn2D) -> void:
	Log.info("Player possessed %s" % pawn)
	_local_player_controller.possessed_pawn = pawn
		
	
func _on_player_unpossessed() -> void:
	Log.info("Player unpossessed")
	_local_player_controller.possessed_pawn = null