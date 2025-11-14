extends Node

signal inventory_set(inventory: InventoryComponent)
signal container_opened(inventory: InventoryComponent)
signal container_closed


func set_inventory(inventory: InventoryComponent) -> void:
	inventory_set.emit(inventory)


func open_container(inventory: InventoryComponent) -> void:
	container_opened.emit(inventory)


func close_container() -> void:
	container_closed.emit()
