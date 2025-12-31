class_name PickupManager extends Node2D

@onready var _item_pickup_scene: PackedScene = preload("res://pickup/item_pickup/item_pickup.tscn")


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


func load(pickups_data: PickupsData) -> void:
	for item_data in pickups_data.items:
		_spawn_item_pickup(item_data)


func spawn_from_item_data(item_data: ItemData, count: int, at: Vector2) -> void:
	var pickup_data = ItemPickupData.new()
	pickup_data.item = item_data
	pickup_data.count = count
	pickup_data.position = at
	rpc_spawn_item_pickup.rpc_id(1, pickup_data.to_dict())


@rpc("any_peer", "call_local", "reliable")
func rpc_spawn_item_pickup(pickup_data_dict: Dictionary) -> void:
	_spawn_item_pickup(ItemPickupData.from_dict(pickup_data_dict))


func _spawn_item_pickup(item_data: ItemPickupData) -> void:
	if not is_multiplayer_authority():
		return

	var node: ItemPickup = _item_pickup_scene.instantiate()

	node.item = item_data.item
	node.count = item_data.count
	node.global_position = item_data.position

	add_child(node, true)


@rpc("any_peer", "call_local", "reliable")
func pick_up(player_path: NodePath, pickup_path: NodePath) -> void:
	Log.info("PickupManager.pick_up called for %s" % pickup_path)
	if not is_multiplayer_authority():
		Log.debug("Not authority, ignoring pick_up call")
		return

	var pickup: ItemPickup = get_tree().root.get_node(pickup_path)
	var player: Player = get_tree().root.get_node(player_path)

	if not pickup:
		Log.err("Pickup node not found at path: %s" % pickup_path)
		return

	if not player:
		Log.err("Player node not found at path: %s" % player_path)
		return

	var rid = multiplayer.get_remote_sender_id()

	player.rpc_add_item_to_inventory.rpc_id(rid, pickup.item.to_dict(), pickup.count)
	pickup.queue_free()
