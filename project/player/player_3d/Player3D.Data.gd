class_name Player3D_Data extends SaveData

var metadata: SaveMetadata = SaveMetadata.new()
var position: Vector3
var rotation: Vector3

const SAVE_DIR = "user://characters_3d/"


func get_save_path() -> String:
	return SAVE_DIR + metadata.name.to_lower()


func get_name() -> String:
	return metadata.name


func get_display_lines() -> PackedStringArray:
	return []


func get_metadata() -> SaveMetadata:
	return metadata


func to_dict() -> Dictionary:
	return {
		"metadata": metadata.to_dict(),
		"position": position,
		"rotation": rotation,
	}


static func from_dict(dict: Dictionary) -> Player3D_Data:
	var data = Player3D_Data.new()
	data.metadata = SaveMetadata.from_dict(dict.get(SaveMetadata.KEY, {}))
	data.position = dict.get("position", Vector3.ZERO)
	data.rotation = dict.get("rotation", Vector3.ZERO)
	return data
