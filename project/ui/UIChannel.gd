extends Node

signal inventory_set(inventory: InventoryComponent)
signal container_opened(inventory: InventoryComponent)


func set_inventory(inventory: InventoryComponent) -> void:
	inventory_set.emit(inventory)


func open_container(inventory: InventoryComponent) -> void:
	container_opened.emit(inventory)
