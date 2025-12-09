extends GdUnitTestSuite

var inventory_data: InventoryData

var item_wood_resource := preload("res://itemization/items/item_wood.tres")
var item_stone_resource := preload("res://itemization/items/item_stone.tres")


func before_test() -> void:
	inventory_data = InventoryData.new()


func test_serde_restores_size():
	var item_data_wood := ItemData.new(item_wood_resource)
	var item_data_stone := ItemData.new(item_stone_resource)

	inventory_data.items[item_data_wood] = 5
	inventory_data.items[item_data_stone] = 3

	var serialized_data := inventory_data.to_dict()
	var deserialized_inventory := InventoryData.from_dict(serialized_data)

	assert_int(deserialized_inventory.items.size()).is_equal(2)


func test_serde_restores_items():
	var item_data_wood := ItemData.new(item_wood_resource)
	var item_data_stone := ItemData.new(item_stone_resource)

	inventory_data.items[item_data_wood] = 5
	inventory_data.items[item_data_stone] = 3

	var serialized_data := inventory_data.to_dict()
	var deserialized_inventory := InventoryData.from_dict(serialized_data)

	var has_wood = false
	var has_stone = false

	for item in deserialized_inventory.items.keys():
		if item == item_data_wood:
			has_wood = true
		elif item == item_data_stone:
			has_stone = true

	assert_bool(has_wood)
	assert_bool(has_stone)


func test_serde_restores_counts():
	var item_data_wood := ItemData.new(item_wood_resource)
	var item_data_stone := ItemData.new(item_stone_resource)

	inventory_data.items[item_data_wood] = 5
	inventory_data.items[item_data_stone] = 3

	var serialized_data := inventory_data.to_dict()
	var deserialized_inventory := InventoryData.from_dict(serialized_data)

	for key in deserialized_inventory.items.keys():
		if key.resource == item_wood_resource:
			assert_int(deserialized_inventory.items[key]).is_equal(5)
		elif key.resource == item_stone_resource:
			assert_int(deserialized_inventory.items[key]).is_equal(3)
