class_name SaveMetadata extends SaveData

var name: String = "Default"
var version: String = "0.1.0"
var last_saved: String = Time.get_datetime_string_from_system(true)

func to_dict() -> Dictionary:
	return {
		"name": name,
		"version": version,
		"last_saved": last_saved
	}

static func from_dict(dict: Dictionary) -> SaveMetadata:
	var metadata = SaveMetadata.new()
	metadata.name = dict.get("name", "Default")
	metadata.version = dict.get("version", "0.1.0")
	metadata.last_saved = dict.get("last_saved", Time.get_date_string_from_system(true))
	return metadata
	