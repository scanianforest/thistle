@tool
class_name InventoryComponent extends Node

signal opened
signal closed
signal item_added(item: ItemData)
signal new_stack_created(item: ItemData)
signal item_removed(item: ItemData)
signal item_rejected(item: ItemData)
signal item_dropped(item: ItemData, count: int)
signal inventory_updated(items: Dictionary[ItemData, int])

var weight:
	get:
		var total_weight: float = 0.0
		for item in items:
			total_weight += item.weight * items[item]
		return total_weight

var max_weight: float = 100.0

var data: InventoryData = InventoryData.new():
	set(value):
		data = value
		items = data.items
	get:
		return data

var items: Dictionary[ItemData, int] = {}:
	set(value):
		items = value
		inventory_updated.emit(items)
	get:
		return items

# RPC-friendly getter/setter of items dictionary
var rpc_items: Dictionary[Dictionary, int]:
	get:
		var dict: Dictionary[Dictionary, int] = {}
		for item in items:
			dict[item.to_dict()] = items[item]
		return dict
	set(value):
		items.clear()
		for item_dict in value.keys():
			var item_data = ItemData.from_dict(item_dict)
			items[item_data] = value[item_dict]
		inventory_updated.emit(items)


func _ready() -> void:
	inventory_updated.emit.call_deferred(items)


func open() -> void:
	opened.emit()


func close() -> void:
	closed.emit()


func can_add_item(item: ItemData) -> bool:
	return item.weight + weight <= max_weight


## Adds multiple items to the inventory. Returns the count of items actually added.
func add_item(item: ItemData, count: int = 1) -> int:
	# Handle non stackable items in a loop
	if not item.resource.stackable:
		for i in count:
			if not _add_item_to_new_stack(item, 1):
				return i
		return count

	# Handle stackable items
	var existing_item: ItemData = get_by_resource(item.resource)

	# We already have a stack
	if existing_item:
		items[existing_item] += count
		item_added.emit(item)
		inventory_updated.emit(items)
		return true

	# New stack
	if not _add_item_to_new_stack(item, count):
		return count
	return true


@rpc("any_peer", "call_local", "reliable")
func rpc_add_item(item_dict: Dictionary, count: int = 1) -> int:
	if not is_multiplayer_authority():
		return 0

	var item_data = ItemData.from_dict(item_dict)
	return add_item(item_data, count)


@rpc("any_peer", "call_local", "reliable")
func rpc_remove_item(item_dict: Dictionary, count: int = 1) -> void:
	if not is_multiplayer_authority():
		Log.debug("Not authority, ignoring rpc_remove_item call")
		return

	Log.info("RPC Remove Item called")
	var item_data = ItemData.from_dict(item_dict)
	remove_item(item_data, count)


func get_by_resource(item_resource: ItemResource) -> ItemData:
	for item in items.keys():
		if item.resource == item_resource:
			return item
	return null


func _add_item_to_new_stack(item: ItemData, count: int) -> bool:
	if false:  # Placeholder for weight check
		item_rejected.emit(item)
		return false

	items[item] = count
	item_added.emit(item)
	new_stack_created.emit(item)
	inventory_updated.emit(items)
	return true


func drop_item(item: ItemData, count: int) -> void:
	if item in items:
		remove_item(item, count)
		item_dropped.emit(item, count)


func remove_item(item: ItemData, count: int = 1) -> void:
	var found_item = null
	for existing_item in items.keys():
		if item.is_equal(existing_item):
			found_item = existing_item
			break

	if not found_item:
		Log.err("Attempted to remove item not in inventory: %s" % item.id)
		return  # Item not found

	if items[found_item] <= count:
		_remove_item(found_item)
	else:
		items[found_item] -= count
		inventory_updated.emit(items)


func _remove_item(item: ItemData) -> void:
	items.erase(item)

	item_removed.emit(item)
	inventory_updated.emit(items)


func contains(item: ItemResource) -> bool:
	return item in items.keys().map(func(i): return i.resource)


func get_item_count(item_resource: ItemResource) -> int:
	var existing_item = get_by_resource(item_resource)
	return items.get(existing_item, 0)
