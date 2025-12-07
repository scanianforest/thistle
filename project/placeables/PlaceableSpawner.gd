extends Node


func spawn(resource: EntityResource, parent: Node, spawn_position: Vector2) -> void:
	var placeable_scene: PackedScene = load(resource.scene_path)
	var node: Node2D = placeable_scene.instantiate()
	node.resource = resource
	parent.add_child(node)
	node.global_position = spawn_position
