extends PanelContainer

var _inventory: InventoryComponent:
	set(value):
		if _inventory:
			_inventory.item_added.disconnect(_on_player_inventory_item_added)
			_inventory.item_removed.disconnect(_on_player_inventory_item_removed)
			_inventory.inventory_updated.disconnect(_on_inventory_updated)
		_inventory = value
		_inventory.item_added.connect(_on_player_inventory_item_added)
		_inventory.item_removed.connect(_on_player_inventory_item_removed)
		_inventory.inventory_updated.connect(_on_inventory_updated)
		_on_inventory_updated(_inventory.items)
	get:
		return _inventory

@onready var _player_inventory_grid: GridContainer = %PlayerInventoryGrid
@onready var itemUI: PackedScene = preload("res://ui/inventory_panel/inventory_item_ui.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("InventoryPanel ready")
	UIChannel.inventory_set.connect(_on_inventory_set)

	for child in _player_inventory_grid.get_children():
		child.queue_free()

	visible = false


func _on_inventory_set(inventory: InventoryComponent) -> void:
	_inventory = inventory


func _on_inventory_updated(items: Array) -> void:
	for child in _player_inventory_grid.get_children():
		child.queue_free()
	for item in items:
		_on_player_inventory_item_added(item)


func _on_player_inventory_item_added(item: Item) -> void:
	var item_ui: InventoryItemUI = itemUI.instantiate()

	item_ui.item = item
	item_ui.drop_requested.connect(_on_item_ui_drop_requested)

	_player_inventory_grid.add_child(item_ui)


func _on_player_inventory_item_removed(item: Item) -> void:
	print(item)
	for child in _player_inventory_grid.get_children():
		if child is InventoryItemUI:
			if child.item == item:
				child.queue_free()


func _on_item_ui_drop_requested(item: Item) -> void:
	_inventory.drop_item(item)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		visible = not visible
