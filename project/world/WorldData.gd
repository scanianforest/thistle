class_name WorldData extends SaveData

var metadata: SaveMetadata = SaveMetadata.new()
var ground_tiles: Dictionary = Dictionary()
var pickups := PickupsData.new()
var entities := EntitiesData.new()

const SAVE_DIR: String = "user://worlds/"


func get_save_path() -> String:
	return (SAVE_DIR + get_name()).to_lower()


func get_name() -> String:
	return metadata.name


func get_metadata() -> SaveMetadata:
	return metadata


func get_display_lines() -> PackedStringArray:
	return []


func to_dict() -> Dictionary:
	return {
		SaveMetadata.KEY: metadata.to_dict(),
		"ground_tiles": ground_tiles,
		EntitiesData.key: entities.to_dict(),
		PickupsData.key: pickups.to_dict()
	}


static func from_dict(dict: Dictionary) -> WorldData:
	var data = WorldData.new()

	data.metadata = SaveMetadata.from_dict(dict.get(SaveMetadata.KEY))
	data.ground_tiles = dict.get("ground_tiles", {})
	data.pickups = PickupsData.from_dict(dict.get(PickupsData.key, PickupsData.new().to_dict()))
	data.entities = EntitiesData.from_dict(dict.get(EntitiesData.key, EntitiesData.new().to_dict()))

	Log.debug("Deserialized world data: ", data.to_dict())
	return data
