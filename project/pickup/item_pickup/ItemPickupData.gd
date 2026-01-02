class_name ItemPickupData

var position: Vector2
var item: ItemData
var count: int = 1


func to_dict() -> Dictionary:
	return {
		"position": position,
		"item": item.to_dict(),
		"count": count,
	}


static func from_dict(dict: Dictionary) -> ItemPickupData:
	var item_data := ItemPickupData.new()
	item_data.position = dict.get("position", Vector2.ZERO)
	item_data.item = ItemData.from_dict(dict.get("item", {}))
	item_data.count = dict.get("count", 1)
	return item_data
