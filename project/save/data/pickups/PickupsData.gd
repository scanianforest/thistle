class_name PickupsData

static var key: String = "pickups"

var items: Array[ItemPickupData] = []


func to_dict() -> Dictionary:
	var dict := {}
	dict.items = []
	for item_data in items:
		var item_dict := {}
		item_dict.position = item_data.position
		item_dict.item = item_data.item.to_dict()
		dict.items.append(item_dict)
	return dict


static func from_dict(dict: Dictionary) -> PickupsData:
	var data := PickupsData.new()
	for item_dict in dict.get("items", []):
		var item_data := ItemPickupData.new()
		item_data.position = item_dict.get("position", Vector2.ZERO)
		item_data.item = ItemData.from_dict(item_dict.get("item", {}))
		data.items.append(item_data)
	return data
