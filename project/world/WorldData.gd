class_name WorldData extends SaveData

var metadata: Metadata = Metadata.new()
var ground_tiles: Dictionary = Dictionary()


class Metadata:
	var name: String = "Unnamed World"
	var version: String = "1"

	func to_dict() -> Dictionary:
		return {
			"name": name,
			"version": version,
		}

	static func from_dict(dict: Dictionary) -> Metadata:
		var metadata = Metadata.new()
		metadata.name = dict.get("name", "Unnamed World")
		metadata.version = dict.get("version", "1")
		return metadata


func to_dict() -> Dictionary:
	return {"metadata": metadata.to_dict(), "ground_tiles": ground_tiles}


static func from_dict(dict: Dictionary) -> WorldData:
	var data = WorldData.new()

	data.metadata = Metadata.from_dict(dict.get("metadata", Metadata.new().to_dict()))
	data.ground_tiles = dict.get("ground_tiles", {})

	Log.pr("Deserialized world data: ", data.to_dict())
	return data
