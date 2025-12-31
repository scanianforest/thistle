class_name InventoryPanelUI extends PanelContainer
## Inventory panel UI that shows player and container inventories.
##
## Its main responsibility is handling inventory display visibility and handling
## top-level item actions, such as moving items between player and container inventories.

@onready var _player_inventory: InventoryComponentUI = %PlayerInventory
@onready var _container_inventory: InventoryComponentUI = %ContainerInventory


func _ready() -> void:
	UIChannel.inventory_set.connect(_on_inventory_set)
	UIChannel.container_opened.connect(_on_container_opened)
	UIChannel.container_closed.connect(_on_container_closed)

	_player_inventory.item_ui_secondary_requested.connect(_on_player_item_secondary_requested)
	_player_inventory.component_opened.connect(_on_player_component_opened)
	_player_inventory.component_closed.connect(_on_player_component_closed)

	_container_inventory.item_ui_secondary_requested.connect(_on_container_item_secondary_requested)

	visible = false


func set_player_inventory(inventory: InventoryComponent) -> void:
	_player_inventory.inventory_comp = inventory


func set_container_inventory(inventory: InventoryComponent) -> void:
	_container_inventory.inventory_comp = inventory


func _on_inventory_set(inventory: InventoryComponent) -> void:
	set_player_inventory(inventory)


func _on_player_component_opened() -> void:
	visible = true


func _on_player_component_closed() -> void:
	visible = false


func _on_container_component_opened() -> void:
	visible = true


func _on_container_component_closed() -> void:
	if not _player_inventory.inventory_comp:
		visible = false


func _on_container_opened(inventory_comp: InventoryComponent) -> void:
	set_container_inventory(inventory_comp)

	visible = true
	_container_inventory.visible = true


func _on_player_item_secondary_requested(item: ItemData) -> void:
	if _container_inventory.inventory_comp:
		_container_inventory.inventory_comp.add_item(item)
		_player_inventory.inventory_comp.remove_item(item)
	else:
		_player_inventory.inventory_comp.drop_item(item, 1)


func _on_container_item_secondary_requested(item: ItemData) -> void:
	_container_inventory.inventory_comp.remove_item(item)
	_player_inventory.inventory_comp.add_item(item)


func _on_container_closed() -> void:
	_container_inventory.inventory_comp = null
	_container_inventory.visible = false


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is InventoryItemUI.DragData


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var drag_data: InventoryItemUI.DragData = data
	var item = drag_data.item
	var count: int = drag_data.count

	_player_inventory.inventory_comp.drop_item(item, count)
