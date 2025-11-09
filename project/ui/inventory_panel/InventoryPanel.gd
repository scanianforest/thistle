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

	_player_inventory.item_ui_secondary_requested.connect(_on_player_item_secondary_requested)
	_container_inventory.item_ui_secondary_requested.connect(_on_container_item_secondary_requested)

	visible = false


func _on_inventory_set(inventory: InventoryComponent) -> void:
	_player_inventory.inventory_comp = inventory


func _on_container_opened(inventory_comp: InventoryComponent) -> void:
	_container_inventory.inventory_comp = inventory_comp

	visible = true
	_container_inventory.visible = true


func _on_player_item_secondary_requested(item: ItemData) -> void:
	if _container_inventory.inventory_comp:
		_container_inventory.inventory_comp.add_item(item)
		_player_inventory.inventory_comp.remove_item(item)
	else:
		_player_inventory.inventory_comp.drop_item(item)


func _on_container_item_secondary_requested(item: ItemData) -> void:
	_container_inventory.inventory_comp.remove_item(item)
	_player_inventory.inventory_comp.add_item(item)


func _on_container_closed() -> void:
	_container_inventory.inventory_comp = null
	_container_inventory.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		visible = not visible
