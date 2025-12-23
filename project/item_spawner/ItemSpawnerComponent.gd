class_name ItemSpawnerComponent extends Node

var floating_item_scene: PackedScene = preload("res://floating_item/floating_item.tscn")


func spawn_item(item: ItemData, count: int, parent: Node, spawn_position: Vector2) -> void:
	var node = floating_item_scene.instantiate()
	node.item = item
	node.count = count
	parent.add_child(node)
	node.global_position = spawn_position
