class_name GameDataFileAccess

static func save_exists(save_name: String) -> bool:
	var path = "user://%s.sav" % save_name.to_lower()
	return FileAccess.file_exists(path)

static func save(save_name: String, data: GameData) -> void:
	var path = "user://%s.sav" % save_name.to_lower()

	var file = FileAccess.open(path, FileAccess.WRITE_READ)
	if file:
		file.store_var(data.to_dict())
		file.close()
	else:
		Log.err("Failed to open file for saving: %s" % path)


static func load(save_name: String) -> GameData:
	var path = "user://%s.sav" % save_name.to_lower()

	var file = FileAccess.open(path, FileAccess.READ)
	if not file: 
		Log.err("Failed to open save file: %s" % path)
		return null

	var game_data_dict: Dictionary = file.get_var()
	if game_data_dict == null:
		Log.err("Failed to parse game data JSON: %s" % game_data_dict.error_string)
		return null

	var game_data: GameData = GameData.from_dict(game_data_dict)

	file.close()
	
	if game_data == null:
		Log.warn("Loaded game data is null, returning default GameData")
		return GameData.new()
	
	return game_data
