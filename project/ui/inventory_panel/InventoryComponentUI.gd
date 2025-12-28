class_name InventoryComponentUI extends Control

signal item_ui_secondary_requested(item_ui: InventoryItemUI)

signal component_opened
signal component_closed

@onready var grid: ItemGrid = %ItemGrid
@onready var owner_name_label: Label = %OwnerName

var inventory_comp: InventoryComponent:
	set(value):
		if inventory_comp:
			Log.info("Disconnecting from previous inventory component signals")
			inventory_comp.opened.disconnect(_on_component_opened)
			inventory_comp.closed.disconnect(_on_component_closed)
			inventory_comp.inventory_updated.disconnect(_on_inventory_updated)
		if value:
			visible = true
			inventory_comp = value
			inventory_comp.opened.connect(_on_component_opened)
			inventory_comp.closed.connect(_on_component_closed)
			inventory_comp.inventory_updated.connect(_on_inventory_updated)
			_on_inventory_updated(inventory_comp.items)
			set_owner_name(inventory_comp.get_parent().name)
		else:
			visible = false
		inventory_comp = value
	get:
		return inventory_comp


func _ready() -> void:
	visible = false


func set_owner_name(new_name: String) -> void:
	owner_name_label.text = new_name


func _on_component_opened() -> void:
	component_opened.emit()


func _on_component_closed() -> void:
	component_closed.emit()


func _on_inventory_updated(items: Dictionary[ItemData, int]) -> void:
	grid.clear_items()
	grid.set_items(items)


func _on_item_ui_secondary_requested(item: ItemData) -> void:
	item_ui_secondary_requested.emit(item)


func _on_item_ui_remove_requested(item: ItemData) -> void:
	inventory_comp.remove_item(item)


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if grid.get_children().find(data) >= 0:
		return false
	return data is InventoryItemUI


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var item_ui := data as InventoryItemUI
	item_ui.remove()
	inventory_comp.add_item(item_ui.item)
