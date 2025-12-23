class_name WorldData extends SaveData

var metadata: Metadata = Metadata.new()
var ground_tiles: Dictionary = Dictionary()
var pickups := PickupsData.new()
var entities := EntitiesData.new()


class Metadata:
	static var key: String = "metadata"

	var name: String = "Unnamed World"
	var version: String = "1"
	var last_loaded: float = Time.get_unix_time_from_system()

	func to_dict() -> Dictionary:
		return {
			"name": name,
			"version": version,
			"last_loaded": last_loaded,
		}

	static func from_dict(dict: Dictionary) -> Metadata:
		var metadata = Metadata.new()
		metadata.name = dict.get("name", "Unnamed World")
		metadata.version = dict.get("version", "1")
		metadata.last_loaded = dict.get("last_loaded", Time.get_unix_time_from_system())
		return metadata


func to_dict() -> Dictionary:
	return {
		Metadata.key: metadata.to_dict(),
		"ground_tiles": ground_tiles,
		EntitiesData.key: entities.to_dict(),
		PickupsData.key: pickups.to_dict()
	}


static func from_dict(dict: Dictionary) -> WorldData:
	var data = WorldData.new()

	data.metadata = Metadata.from_dict(dict.get(Metadata.key, Metadata.new().to_dict()))
	data.ground_tiles = dict.get("ground_tiles", {})
	data.pickups = PickupsData.from_dict(dict.get(PickupsData.key, PickupsData.new().to_dict()))
	data.entities = EntitiesData.from_dict(dict.get(EntitiesData.key, EntitiesData.new().to_dict()))

	print("Deserialized world data: ", data.to_dict())
	return data
