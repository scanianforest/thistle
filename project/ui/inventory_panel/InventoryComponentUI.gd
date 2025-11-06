class_name InventoryComponentUI extends VBoxContainer

var inventory_comp: InventoryComponent:
	set(value):
		if inventory_comp:
			inventory_comp.item_added.disconnect(_on_inventory_item_added)
			inventory_comp.item_removed.disconnect(_on_inventory_item_removed)
			inventory_comp.inventory_updated.disconnect(_on_inventory_updated)
		inventory_comp = value
		inventory_comp.item_added.connect(_on_inventory_item_added)
		inventory_comp.item_removed.connect(_on_inventory_item_removed)
		inventory_comp.inventory_updated.connect(_on_inventory_updated)
		_on_inventory_updated(inventory_comp.items)
		set_owner_name(inventory_comp.get_parent().name)
	get:
		return inventory_comp

var _item_ui_scene: PackedScene = preload("res://ui/inventory_panel/inventory_item_ui.tscn")


func set_owner_name(new_name: String) -> void:
	var owner_label: Label = $OwnerName
	owner_label.text = new_name


func _on_inventory_item_added(item: Item) -> void:
	var item_ui: InventoryItemUI = _item_ui_scene.instantiate()
	item_ui.item = item
	item_ui.drop_requested.connect(_on_item_ui_drop_requested)
	$ItemGrid.add_child(item_ui)


func _on_inventory_item_removed(item: Item) -> void:
	for child in $ItemGrid.get_children():
		if child is InventoryItemUI and child.item == item:
			child.queue_free()
			break


func _on_inventory_updated(items: Array[Item]) -> void:
	_refresh_items(items)


func _on_item_ui_drop_requested(item: Item) -> void:
	# Assuming the InventoryComponent is stored as a variable
	inventory_comp.drop_item(item)


func _refresh_items(items: Array[Item]) -> void:
	for child in $ItemGrid.get_children():
		child.queue_free()
	for item in items:
		var item_ui: InventoryItemUI = _item_ui_scene.instantiate()
		item_ui.item = item
		item_ui.drop_requested.connect(_on_item_ui_drop_requested)
		$ItemGrid.add_child(item_ui)
