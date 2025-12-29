class_name ItemSpawnerComponent extends Node

var item_pickup_scene: PackedScene = preload("res://pickup/item_pickup/item_pickup.tscn")


func spawn_item(item: ItemData, count: int, parent: Node, spawn_position: Vector2) -> void:
	_spawn_item.rpc(item.to_dict(), count, parent, spawn_position)


@rpc("any_peer", "call_remote")
func _spawn_item(item_dict: Dictionary, count: int, parent: Node, spawn_position: Vector2) -> void:
	var item = ItemData.from_dict(item_dict)
	var node = item_pickup_scene.instantiate()
	node.item = item
	node.count = count
	parent.add_child(node)
	node.global_position = spawn_position
