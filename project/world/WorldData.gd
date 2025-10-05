class_name WorldData extends SaveData

var ground_tiles: Dictionary = Dictionary()

func to_dict() -> Dictionary:
	return {
		"ground_tiles": ground_tiles
	}


static func from_dict(dict: Dictionary) -> WorldData:
	var data = WorldData.new()
	
	data.ground_tiles = dict.get("ground_tiles", {})

	Log.pr("Deserialized world data: ", data.to_dict())
	return data

