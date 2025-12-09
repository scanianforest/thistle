class_name InventoryData

var items: Dictionary[ItemData, int] = {}


func to_dict() -> Dictionary:
	var items_dict: Dictionary = {}

	for item in items.keys():
		var item_dict = item.to_dict()
		var count = items[item]
		items_dict[item_dict] = count

	return {"items": items_dict}


static func from_dict(data: Dictionary) -> InventoryData:
	var inventory_data: InventoryData = InventoryData.new()
	var items_dict: Dictionary = data.get("items", {})

	var items_to_assign: Dictionary[ItemData, int] = {}

	for item_key in items_dict.keys():
		var item_data = ItemData.from_dict(item_key)
		var count = items_dict[item_key]
		items_to_assign[item_data] = count

	inventory_data.items = items_to_assign

	Log.pr("Deserialized inventory data: ", inventory_data.to_dict())
	return inventory_data
