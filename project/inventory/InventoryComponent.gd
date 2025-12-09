@tool
class_name InventoryComponent extends Node

signal opened
signal closed
signal item_added(item: ItemData)
signal item_removed(item: ItemData)
signal item_rejected(item: ItemData)
signal item_dropped(item: ItemData)
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
			if not _add_item(item):
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
	items[item] = count
	item_added.emit(item)
	inventory_updated.emit(items)
	return true


func get_by_resource(item_resource: ItemResource) -> ItemData:
	for item in items.keys():
		if item.resource == item_resource:
			return item
	return null


func _add_item(item: ItemData) -> bool:
	if false:  # Placeholder for weight check
		item_rejected.emit(item)
		return false

	items[item] = 1
	item_added.emit(item)
	inventory_updated.emit(items)
	return true


func drop_item(item) -> void:
	if item in items:
		_remove_item(item)
		item_dropped.emit(item)


func remove_item(item: ItemData, count: int = 1) -> void:
	if item not in items:
		return

	if items[item] <= count:
		_remove_item(item)
	else:
		items[item] -= count
		inventory_updated.emit(items)


func _remove_item(item) -> void:
	items.erase(item)

	item_removed.emit(item)
	inventory_updated.emit(items)


func contains(item: ItemResource) -> bool:
	return item in items.keys().map(func(i): return i.resource)


func get_item_count(item_resource: ItemResource) -> int:
	var existing_item = get_by_resource(item_resource)
	return items.get(existing_item, 0)


func serialize() -> Dictionary:
	var item_ids: Array = []
	for item in items:
		item_ids.append(item.resource_id)
	return {"item_ids": item_ids}
