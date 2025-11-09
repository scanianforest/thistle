class_name InventoryComponent extends Node

signal item_added(item: ItemData)
signal item_removed(item: ItemData)
signal item_rejected(item: ItemData)
signal item_dropped(item: ItemData)
signal inventory_updated(items: Array[ItemData])

var weight: float = 0.0
var max_weight: float = 100.0

var data: InventoryData = InventoryData.new():
	set(value):
		data = value
		items = data.items
	get:
		return data

var items: Array[ItemData] = [ItemData.new(preload("res://itemization/items/tool_wooden_hoe.tres"))]:
	set(value):
		items = value
		inventory_updated.emit(items)
	get:
		return items


func _ready() -> void:
	inventory_updated.emit.call_deferred(items)


func add_item(item: ItemData) -> void:
	if false:  # Placeholder for weight check
		item_rejected.emit(item)
		return

	items.append(item)

	item_added.emit(item)
	inventory_updated.emit(items)


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
