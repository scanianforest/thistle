extends Node

signal inventory_set(inventory: InventoryComponent)


func set_inventory(inventory: InventoryComponent) -> void:
	inventory_set.emit(inventory)
