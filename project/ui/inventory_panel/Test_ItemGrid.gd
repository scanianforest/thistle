extends GdUnitTestSuite

@onready var wood_item_resource: ItemResource = preload("res://itemization/items/item_wood.tres")
@onready var stone_item_resource: ItemResource = preload("res://itemization/items/item_stone.tres")

var runner: GdUnitSceneRunner
var sut: ItemGrid


func before_test() -> void:
	runner = scene_runner("res://ui/inventory_panel/item_grid.tscn")
	sut = runner.scene()


func test_new_item_populates_item_grid() -> void:
	var wood: ItemData = ItemData.new(wood_item_resource)
	var stone: ItemData = ItemData.new(stone_item_resource)

	sut.set_items({wood: 10, stone: 2})
	var sut_child_count = sut.get_child_count()

	assert_int(sut_child_count).is_equal(2)
