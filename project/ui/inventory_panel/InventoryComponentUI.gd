class_name InventoryComponentUI extends Control

signal item_ui_secondary_requested(item_ui: InventoryItemUI)

signal component_opened
signal component_closed

var inventory_comp: InventoryComponent:
	set(value):
		if inventory_comp:
			inventory_comp.opened.disconnect(_on_component_opened)
			inventory_comp.closed.disconnect(_on_component_closed)
			inventory_comp.item_added.disconnect(_on_inventory_item_added)
			inventory_comp.item_removed.disconnect(_on_inventory_item_removed)
			inventory_comp.inventory_updated.disconnect(_on_inventory_updated)
		if value:
			visible = true
			inventory_comp = value
			inventory_comp.opened.connect(_on_component_opened)
			inventory_comp.closed.connect(_on_component_closed)
			inventory_comp.item_added.connect(_on_inventory_item_added)
			inventory_comp.item_removed.connect(_on_inventory_item_removed)
			inventory_comp.inventory_updated.connect(_on_inventory_updated)
			_on_inventory_updated(inventory_comp.items)
			set_owner_name(inventory_comp.get_parent().name)
		else:
			visible = false
	get:
		return inventory_comp

var _item_ui_scene: PackedScene = preload("res://ui/inventory_panel/inventory_item_ui.tscn")


func _ready() -> void:
	visible = false


func set_owner_name(new_name: String) -> void:
	var owner_label: Label = %OwnerName
	owner_label.text = new_name


func _add_item_ui(item: ItemData) -> void:
	var item_ui: InventoryItemUI = _item_ui_scene.instantiate()
	item_ui.item = item
	item_ui.secondary_requested.connect(_on_item_ui_secondary_requested)
	item_ui.remove_requested.connect(_on_item_ui_remove_requested)
	%ItemGrid.add_child(item_ui)


func _on_component_opened() -> void:
	Log.pr("Component opened")
	component_opened.emit()


func _on_component_closed() -> void:
	component_closed.emit()


func _on_inventory_item_added(item: ItemData) -> void:
	_add_item_ui(item)


func _on_inventory_item_removed(item: ItemData) -> void:
	for child in %ItemGrid.get_children():
		if child is InventoryItemUI and child.item == item:
			child.queue_free()
			break


func _on_inventory_updated(items: Array[ItemData]) -> void:
	_refresh_items(items)


func _on_item_ui_secondary_requested(item: ItemData) -> void:
	item_ui_secondary_requested.emit(item)


func _on_item_ui_remove_requested(item: ItemData) -> void:
	inventory_comp.remove_item(item)


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if %ItemGrid.get_children().find(data) >= 0:
		return false
	return data is InventoryItemUI


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var item_ui := data as InventoryItemUI
	print("Transfering item: ", item_ui.item)
	item_ui.remove()
	inventory_comp.add_item(item_ui.item)


func _refresh_items(items: Array[ItemData]) -> void:
	for child in %ItemGrid.get_children():
		child.queue_free()
	for item in items:
		_add_item_ui(item)
