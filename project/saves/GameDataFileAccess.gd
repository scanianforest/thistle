class_name GameDataFileAccess

const DEFAULT_SAVE_PATH: String = "res://saves/default.sav"

static func create_default_save() -> void:
	if FileAccess.file_exists(DEFAULT_SAVE_PATH): return

	var file = FileAccess.open(DEFAULT_SAVE_PATH, FileAccess.WRITE_READ)
	if file:
		var default_data = GameData.new()
		file.store_var(default_data.to_dict())
		file.close()
	else:
		Log.err("Failed to open file for creating default save: %s" % DEFAULT_SAVE_PATH)

static func save(path: String, data: GameData) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE_READ)
	if file:
		file.store_var(data.to_dict())
		file.close()
	else:
		push_error("Failed to open file for saving: %s" % path)


static func load(path: String) -> GameData:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file: return null

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
