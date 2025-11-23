class_name ItemPickupData

var position: Vector2
var item: ItemData


func to_dict() -> Dictionary:
	return {
		"position": position,
		"item": item.to_dict(),
	}


static func from_dict(dict: Dictionary) -> ItemPickupData:
	var item_data := ItemPickupData.new()
	item_data.position = dict.get("position", Vector2.ZERO)
	item_data.item = ItemData.from_dict(dict.get("item", {}))
	return item_data
