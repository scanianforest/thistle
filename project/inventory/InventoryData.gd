class_name InventoryData

var items: Array[ItemData] = []


func to_dict() -> Dictionary:
	var items_dicts: Array = []

	for item in items:
		items_dicts.append(item.to_dict())

	return {"items": items_dicts}


static func from_dict(data: Dictionary) -> InventoryData:
	var inventory_data: InventoryData = InventoryData.new()
	var items_dicts: Array = data.get("items", [])

	for item_dict in items_dicts:
		var item_data = ItemData.from_dict(item_dict)
		inventory_data.items.append(item_data)

	Log.pr("Deserialized inventory data: ", inventory_data.to_dict())
	return inventory_data
