class_name PickupsManager extends Node2D

@onready var _item_pickup_scene: PackedScene = preload("res://floating_item/floating_item.tscn")


func _ready() -> void:
	pass


func clear() -> void:
	for pickup in get_children():
		if pickup is ItemPickup:
			pickup.queue_free()


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


@rpc("authority", "call_remote")
func rpc_spawn_item_pickup(item_data_dict: Dictionary) -> void:
	var item_data = ItemPickupData.from_dict(item_data_dict)
	spawn_item_pickup(item_data)


func spawn_item_pickup(item_data: ItemPickupData) -> void:
	var node = _item_pickup_scene.instantiate()
	node.resource = item_data.item.resource
	add_child(node, true)
	node.global_position = item_data.position
