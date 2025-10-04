extends Node

var _player_scene = preload("res://player/Player.tscn")
var _player_node: CharacterBody2D
@export var _player_node_parent: Node


func _ready() -> void:
	spawn(Vector2.ZERO)

func spawn(global_position: Vector2) -> CharacterBody2D:
	_player_node = _player_scene.instantiate()
	_player_node.global_position = global_position  # Use global_position for consistency
	
	if _player_node_parent:
		_player_node_parent.add_child(_player_node)
	else:
		Log.warn("No parent node set, spawning as child of self")
		add_child(_player_node)
	
	return _player_node
