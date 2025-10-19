class_name InventoryComponent extends Node

var items: Array[ItemResource] = []

func add_item(item: ItemResource) -> void:
	items.append(item)

	PlayerChannel.on_inventory_item_added(item)
	PlayerChannel.on_inventory_updated(items)

func remove_item(item) -> void:
	items.erase(item)
	PlayerChannel.on_inventory_item_removed(item)
	PlayerChannel.on_inventory_updated(items)
