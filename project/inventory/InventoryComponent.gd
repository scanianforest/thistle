@tool
class_name InventoryComponent extends Node

signal opened
signal closed
signal item_added(item: ItemData)
signal item_removed(item: ItemData)
signal item_rejected(item: ItemData)
signal item_dropped(item: ItemData)
signal inventory_updated(items: Array[ItemData])

@export var starting_items: Array[ItemResource] = []

var weight: float = 0.0
var max_weight: float = 100.0

var data: InventoryData = InventoryData.new():
	set(value):
		data = value
		items = data.items
	get:
		return data

var items: Array[ItemData] = []:
	set(value):
		items = value
		inventory_updated.emit(items)
	get:
		return items


func _ready() -> void:
	for item_res in starting_items:
		var item_data = ItemData.new(item_res)
		items.append(item_data)
	inventory_updated.emit.call_deferred(items)


func open() -> void:
	opened.emit()


func close() -> void:
	closed.emit()


func can_add_item(item: ItemData) -> bool:
	return item.weight + weight <= max_weight


func add_item(item: ItemData) -> bool:
	if false:  # Placeholder for weight check
		item_rejected.emit(item)
		return false

	items.append(item)

	item_added.emit(item)
	inventory_updated.emit(items)
	return true


func drop_item(item) -> void:
	if item in items:
		remove_item(item)
		item_dropped.emit(item)


func remove_item(item) -> void:
	items.erase(item)

	item_removed.emit(item)
	inventory_updated.emit(items)


func serialize() -> Dictionary:
	var item_ids: Array = []
	for item in items:
		item_ids.append(item.resource_id)
	return {"item_ids": item_ids}
