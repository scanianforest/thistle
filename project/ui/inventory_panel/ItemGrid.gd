class_name ItemGrid extends GridContainer

@onready var item_ui_scene: PackedScene = preload("res://ui/inventory_panel/inventory_item_ui.tscn")


func _ready() -> void:
	clear_items()


func set_items(items: Dictionary[ItemData, int], inventory: InventoryComponent) -> void:
	clear_items()
	for item_data in items:
		var item_ui: InventoryItemUI = item_ui_scene.instantiate() as InventoryItemUI
		item_ui.item = item_data
		item_ui.count = items[item_data]
		item_ui.inventory = inventory
		add_child(item_ui)


func clear_items() -> void:
	for child in get_children():
		child.queue_free()
