class_name SaveMetadata

static var KEY: String = "metadata"

var name: String = "Default"
var version: String = "1"
var last_saved: float = Time.get_unix_time_from_system()


func to_dict() -> Dictionary:
	return {"name": name, "version": version, "last_saved": last_saved}


static func from_dict(dict: Dictionary) -> SaveMetadata:
	if dict == null:
		return SaveMetadata.new()

	var metadata = SaveMetadata.new()
	metadata.name = dict.get("name", "Default")
	metadata.version = dict.get("version", "0.1.0")
	metadata.last_saved = dict.get("last_saved", Time.get_unix_time_from_system())
	return metadata
