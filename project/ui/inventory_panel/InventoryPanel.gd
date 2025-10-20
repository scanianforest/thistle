extends PanelContainer


@onready var _player_inventory_grid: GridContainer = %PlayerInventoryGrid
@onready var itemUI: PackedScene = preload("res://ui/inventory_panel/inventory_item_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerChannel.inventory_item_added.connect(_on_player_inventory_item_added)
	PlayerChannel.inventory_item_removed.connect(_on_player_inventory_item_removed)

	for child in _player_inventory_grid.get_children():
		child.queue_free()
	
	visible = false


func _on_player_inventory_item_added(item: Item) -> void:
	var item_ui: InventoryItemUI = itemUI.instantiate()
	item_ui.item = item
	_player_inventory_grid.add_child(item_ui)

func _on_player_inventory_item_removed(item: Item) -> void:
	for child in _player_inventory_grid.get_children():
		if child is InventoryItemUI:
			if child.item == item:
				child.queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		visible = not visible
