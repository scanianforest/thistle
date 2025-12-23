extends GdUnitTestSuite
var item_wood_resource := preload("res://itemization/items/item_wood.tres")
var item_stone_resource := preload("res://itemization/items/item_stone.tres")

var runner: GdUnitSceneRunner

var ui: InventoryItemUI

@warning_ignore_start("redundant_await")


func before_test() -> void:
	runner = scene_runner("res://ui/inventory_panel/inventory_item_ui.tscn")
	ui = runner.scene() as InventoryItemUI


func test_setting_item_updates_texture() -> void:
	var item_data_wood := ItemData.new(item_wood_resource)

	ui.item = item_data_wood

	var wood_image := item_wood_resource.inventory_icon.get_image().get_data()
	var ui_image := ui._texture.texture.get_image().get_data()

	assert_array(wood_image).is_equal(ui_image)


func test_setting_count_updates_label() -> void:
	ui.count = 5

	assert_str(ui._count_label.text).is_equal("5")
