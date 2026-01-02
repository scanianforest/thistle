class_name CharacterData extends SaveData

var metadata: SaveMetadata = SaveMetadata.new()
var position: Vector2 = Vector2.ZERO
var inventory_data: InventoryData = InventoryData.new()
var actionbar_data: ActionBarData = ActionBarData.new()

static var SAVE_DIR: String = "user://characters/"


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
		"metadata": metadata.to_dict(),
		"position": position,
		"inventory_data": inventory_data.to_dict(),
		"actionbar_data": actionbar_data.to_dict(),
	}


static func from_dict(dict: Dictionary) -> CharacterData:
	var data = CharacterData.new()

	data.metadata = SaveMetadata.from_dict(dict.get(SaveMetadata.KEY))
	data.position = dict.get("position", Vector2.ZERO)
	data.inventory_data = InventoryData.from_dict(
		dict.get("inventory_data", InventoryData.new().to_dict())
	)
	data.actionbar_data = ActionBarData.from_dict(
		dict.get("actionbar_data", ActionBarData.new().to_dict())
	)

	Log.debug("Deserialized player data: ", data.to_dict())
	return data
