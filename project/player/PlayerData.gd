class_name PlayerData extends SaveData


class Metadata:
	var name: String = "Unnamed Player"
	var version: String = "1"
	var last_loaded: float = Time.get_unix_time_from_system()

	func to_dict() -> Dictionary:
		return {
			"name": name,
			"version": version,
			"last_played": last_loaded,
		}

	static func from_dict(dict: Dictionary) -> Metadata:
		var metadata = Metadata.new()
		metadata.name = dict.get("name", "Unnamed Player")
		metadata.version = dict.get("version", "1")
		metadata.last_loaded = dict.get("last_loaded", Time.get_unix_time_from_system())
		return metadata


var metadata: Metadata = Metadata.new()
var position: Vector2 = Vector2.ZERO
var inventory_data: InventoryData = InventoryData.new()
var actionbar_data: ActionBarData = ActionBarData.new()

var name:
	get:
		return metadata.name


func to_dict() -> Dictionary:
	return {
		"metadata": metadata.to_dict(),
		"position": position,
		"inventory_data": inventory_data.to_dict(),
		"actionbar_data": actionbar_data.to_dict(),
	}


static func from_dict(dict: Dictionary) -> PlayerData:
	var data = PlayerData.new()

	data.metadata = Metadata.from_dict(dict.get("metadata", Metadata.new().to_dict()))
	data.position = dict.get("position", Vector2.ZERO)
	data.inventory_data = InventoryData.from_dict(
		dict.get("inventory_data", InventoryData.new().to_dict())
	)
	data.actionbar_data = ActionBarData.from_dict(
		dict.get("actionbar_data", ActionBarData.new().to_dict())
	)

	Log.debug("Deserialized player data: ", data.to_dict())
	return data
