extends Node

@export var player_scene: PackedScene


func build(data: Dictionary) -> Node:
	var player_node: Node = player_scene.instantiate()

	player_node.name = node_name
	player_node.set_multiplayer_authority(id)

	return
