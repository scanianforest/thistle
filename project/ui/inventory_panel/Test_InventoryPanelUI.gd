extends GdUnitTestSuite

var item_wood_resource := preload("res://itemization/items/item_wood.tres")
var item_stone_resource := preload("res://itemization/items/item_stone.tres")

var runner: GdUnitSceneRunner
var ui: InventoryPanelUI

var player_inventory: InventoryComponent
var other_inventory: InventoryComponent


func before_test() -> void:
	runner = scene_runner("res://ui/inventory_panel/inventory_panel.tscn")
	ui = runner.scene() as InventoryPanelUI

	var player_node: Node = auto_free(Node.new())
	var other_node: Node = auto_free(Node.new())

	player_inventory = InventoryComponent.new()
	other_inventory = InventoryComponent.new()

	player_node.add_child(player_inventory)
	other_node.add_child(other_inventory)


func test_new_panel_shows_no_inventories() -> void:
	assert_bool(ui._player_inventory.visible).is_false()
	assert_bool(ui._container_inventory.visible).is_false()


func test_init_player_inventory_shows_player_inventory() -> void:
	ui._player_inventory.inventory_comp = player_inventory
	assert_bool(ui._player_inventory.visible).is_true()


func test_opening_container_shows_container_inventory() -> void:
	ui._container_inventory.inventory_comp = other_inventory
	assert_bool(ui._container_inventory.visible).is_true()
