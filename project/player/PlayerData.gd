class_name PlayerData extends SaveData

var position: Vector2 = Vector2.ZERO
var items: Array[Item] = []


func to_dict() -> Dictionary:
	return {
		"position": position,
		"items": items,
	}


static func from_dict(dict: Dictionary) -> PlayerData:
	var data = PlayerData.new()

	data.position = dict.get("position", Vector2.ZERO)
	data.items = dict.get("items", [] as Array[Item])

	Log.pr("Deserialized player data: ", data.to_dict())
	return data
