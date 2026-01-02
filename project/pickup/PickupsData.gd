class_name PickupsData

static var key: String = "pickups"

var items: Array[ItemPickupData] = []


func to_dict() -> Dictionary:
	var item_dicts = items.map(
		func(item_data: ItemPickupData) -> Dictionary: return item_data.to_dict()
	)

	return {"items": item_dicts}


static func from_dict(dict: Dictionary) -> PickupsData:
	var data := PickupsData.new()

	for item_dict in dict.get("items", []):
		var item_data = ItemPickupData.from_dict(item_dict)
		data.items.append(item_data)

	return data
