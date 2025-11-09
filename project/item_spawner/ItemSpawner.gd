extends Node

var item_pickup_area_scene: PackedScene = preload("res://interaction/pickup/item_pickup_area.tscn")


func spawn_item(item: ItemData, parent: Node, spawn_position: Vector2) -> void:
	var node: ItemPickupArea = item_pickup_area_scene.instantiate()
	node.item = item
	parent.add_child(node)
	node.global_position = spawn_position
