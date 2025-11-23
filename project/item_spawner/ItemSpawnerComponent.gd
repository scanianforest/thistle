class_name ItemSpawnerComponent extends Node

var item_pickup_area_scene: PackedScene = preload("res://pickup/item_pickup.tscn")


func spawn_item(item: ItemData, parent: Node, spawn_position: Vector2) -> void:
	var node: ItemPickup = item_pickup_area_scene.instantiate()
	node.item = item
	parent.add_child(node)
	node.global_position = spawn_position
