class_name PickupsManager extends Node2D

@onready var _item_pickup_scene: PackedScene = preload("res://pickup/item_pickup.tscn")


func save(world_data: WorldData) -> void:
	var pickups_data = PickupsData.new()
	for pickup in get_children():
		if pickup is ItemPickup:
			var item_data := ItemPickupData.new()
			item_data.position = pickup.global_position
			item_data.item = pickup.item
			pickups_data.items.append(item_data)

	world_data.pickups = pickups_data


func load(world_data: WorldData) -> void:
	for item_data in world_data.pickups.items:
		spawn_item_pickup(item_data)


func spawn_item_pickup(item_data: ItemPickupData) -> void:
	var node: ItemPickup = _item_pickup_scene.instantiate()
	node.item = item_data.item
	add_child(node)
	node.global_position = item_data.position
