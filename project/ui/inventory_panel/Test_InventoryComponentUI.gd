extends GdUnitTestSuite

var ui_scene: PackedScene = preload("res://ui/inventory_panel/inventory_component_ui.tscn")

var ui: InventoryComponentUI
var parent: Node
var inventory_component: InventoryComponent


func before_test() -> void:
	ui = ui_scene.instantiate() as InventoryComponentUI

	parent = Node.new()
	parent.name = "TestParent"

	inventory_component = InventoryComponent.new()

	parent.add_child(inventory_component)
	add_child(ui)
	add_child(parent)

	ui.inventory_comp = inventory_component


func after_test() -> void:
	ui.queue_free()
	inventory_component.queue_free()


func test_inventory_owner_label_is_parent_name() -> void:
	assert(ui.owner_name_label.text == "TestParent")
