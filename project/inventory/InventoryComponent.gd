class_name InventoryComponent extends Node

var items: Array[Item] = []

func add_item(item: Item) -> void:
	items.append(item)

	PlayerChannel.on_inventory_item_added(item)
	PlayerChannel.on_inventory_updated(items)

func remove_item(item) -> void:
	items.erase(item)
	PlayerChannel.on_inventory_item_removed(item)
	PlayerChannel.on_inventory_updated(items)

func serialize() -> Dictionary:
	var item_ids: Array = []
	for item in items:
		item_ids.append(item.resource_id)
	return {
		"item_ids": item_ids
	}