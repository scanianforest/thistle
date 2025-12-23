extends GdUnitTestSuite

var stackable_item_res := preload("res://itemization/items/item_debug_stackable_item.tres")
var non_stackable_item_res := preload("res://itemization/items/item_debug_nonstackable_item.tres")

var inventory_comp: InventoryComponent


func before_test() -> void:
	inventory_comp = InventoryComponent.new()


func after_test() -> void:
	inventory_comp.free()


func test_new_inventory_is_empty():
	assert_int(inventory_comp.get_item_count(stackable_item_res)).is_equal(0)


func test_new_inventory_does_not_have_item():
	var item_data := ItemData.new(stackable_item_res)

	var item_count = inventory_comp.get_item_count(item_data.resource)

	assert_int(item_count).is_equal(0)


func test_inventory_contains_added_item_data():
	var item_data: ItemData = ItemData.new(stackable_item_res)

	inventory_comp.add_item(item_data)

	assert_bool(inventory_comp.contains(item_data.resource)).is_true()


func test_add_non_stackable_item_increases_size():
	var item_data: ItemData = ItemData.new(non_stackable_item_res)
	var other_item_data: ItemData = ItemData.new(non_stackable_item_res)

	inventory_comp._add_item_to_new_stack(item_data)
	inventory_comp._add_item_to_new_stack(other_item_data)

	assert_int(inventory_comp.items.size()).is_equal(2)


func test_add_stackable_item_creates_stack():
	var item_data: ItemData = ItemData.new(stackable_item_res)

	inventory_comp.add_item(item_data, 1)

	assert_int(inventory_comp.items.size()).is_equal(1)


func test_add_stackable_item_increases_count():
	var item_data: ItemData = ItemData.new(stackable_item_res)
	var item_data_duplicate: ItemData = ItemData.new(stackable_item_res)

	inventory_comp.add_item(item_data, 3)
	inventory_comp.add_item(item_data_duplicate, 2)

	var item_count = inventory_comp.get_item_count(item_data.resource)

	assert_int(inventory_comp.items.size()).is_equal(1)
	assert_int(item_count).is_equal(5)
	print(item_data)


func test_remove_stackable_item_decreases_size():
	var item_data: ItemData = ItemData.new(stackable_item_res)

	inventory_comp.add_item(item_data, 5)

	assert_int(inventory_comp.items.size()).is_equal(1)

	inventory_comp.remove_item(item_data, 5)

	assert_int(inventory_comp.items.size()).is_equal(0)


func test_remove_stackable_item_decreases_count():
	var item_data: ItemData = ItemData.new(stackable_item_res)

	inventory_comp.add_item(item_data, 5)

	assert_int(inventory_comp.items.size()).is_equal(1)

	inventory_comp.remove_item(item_data, 3)

	var item_count = inventory_comp.get_item_count(item_data.resource)

	assert_int(inventory_comp.items.size()).is_equal(1)
	assert_int(item_count).is_equal(2)


func test_remove_non_stackable_item_decreases_size():
	var item_data: ItemData = ItemData.new(non_stackable_item_res)
	var other_item_data: ItemData = ItemData.new(non_stackable_item_res)

	inventory_comp._add_item_to_new_stack(item_data)
	inventory_comp._add_item_to_new_stack(other_item_data)

	assert_int(inventory_comp.items.size()).is_equal(2)

	inventory_comp.remove_item(item_data)

	assert_int(inventory_comp.items.size()).is_equal(1)
