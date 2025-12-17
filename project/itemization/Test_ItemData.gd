extends GdUnitTestSuite

var item_data: ItemData
var second_item_data: ItemData
var third_item_data: ItemData


func before() -> void:
	item_data = ItemData.new(load("res://itemization/items/item_wood.tres"))
	second_item_data = ItemData.new(load("res://itemization/items/item_stone.tres"))
	third_item_data = ItemData.new(load("res://itemization/items/item_wood.tres"))


func test_init_assigns_resource():
	assert_object(item_data.resource).is_not_null()


func test_different_data_instances_are_not_same():
	assert_object(item_data).is_not_same(second_item_data).is_not_same(third_item_data)


func test_serde_preserves_resource():
	var serialized_data := item_data.to_dict()
	var deserialized_item := ItemData.from_dict(serialized_data)

	assert_object(deserialized_item.resource).is_equal(item_data.resource)
