extends PanelContainer

@onready var _player_inventory: InventoryComponentUI = %PlayerInventory
@onready var _container_inventory: InventoryComponentUI = %ContainerInventory


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("InventoryPanel ready")
	UIChannel.inventory_set.connect(_on_inventory_set)
	UIChannel.container_opened.connect(_on_container_opened)

	visible = false


func _on_inventory_set(inventory: InventoryComponent) -> void:
	_player_inventory.inventory_comp = inventory


func _on_container_opened(inventory_comp: InventoryComponent) -> void:
	_container_inventory.inventory_comp = inventory_comp

	visible = true
	_container_inventory.visible = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		visible = not visible
