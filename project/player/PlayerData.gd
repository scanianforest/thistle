class_name PlayerData extends SaveData

var position: Vector2 = Vector2.ZERO
var inventory_data: InventoryData = InventoryData.new()


func to_dict() -> Dictionary:
	return {
		"position": position,
		"inventory_data": inventory_data.to_dict(),
	}


static func from_dict(dict: Dictionary) -> PlayerData:
	var data = PlayerData.new()

	data.position = dict.get("position", Vector2.ZERO)
	data.inventory_data = InventoryData.from_dict(
		dict.get("inventory_data", InventoryData.new().to_dict())
	)

	Log.pr("Deserialized player data: ", data.to_dict())
	return data
