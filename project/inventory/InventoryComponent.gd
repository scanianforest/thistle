class_name InventoryComponent extends Node

signal item_added(item: Item)
signal item_removed(item: Item)
signal item_rejected(item: Item)
signal item_dropped(item: Item)
signal inventory_updated(items: Array[Item])

var weight: float = 0.0
var max_weight: float = 100.0

var items: Array[Item] = [Item.new(preload("res://itemization/items/tool_wooden_hoe.tres"))]


func _ready() -> void:
	inventory_updated.emit.call_deferred(items)


func add_item(item: Item) -> void:
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
