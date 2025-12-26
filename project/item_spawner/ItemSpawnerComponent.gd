class_name ItemSpawnerComponent extends Node

var floating_item_scene: PackedScene = preload("res://floating_item/floating_item.tscn")


func spawn_item(item: ItemData, count: int, parent: Node, spawn_position: Vector2) -> void:
	_spawn_item.rpc(item.to_dict(), count, parent, spawn_position)


@rpc("any_peer", "call_remote")
func _spawn_item(item_dict: Dictionary, count: int, parent: Node, spawn_position: Vector2) -> void:
	var item = ItemData.from_dict(item_dict)
	var node = floating_item_scene.instantiate()
	node.item = item
	node.count = count
	parent.add_child(node)
	node.global_position = spawn_position
