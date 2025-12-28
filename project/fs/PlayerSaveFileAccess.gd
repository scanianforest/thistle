class_name PlayerSaveFileAccess

const PLAYER_SAVE_DIR = "user://saves/players/"


static func create_player_save_directory() -> void:
	var dir = DirAccess.make_dir_absolute(PLAYER_SAVE_DIR)
	if dir == null:
		Log.err("Failed to create player saves directory")


static func exists(player_name: String) -> bool:
	var path = PLAYER_SAVE_DIR + player_name.to_lower()
	return FileAccess.file_exists(path)


static func get_save_names() -> PackedStringArray:
	var dir = DirAccess.open(PLAYER_SAVE_DIR)
	return dir.get_files()


static func get_saves() -> Array[PlayerData]:
	var dir = DirAccess.open(PLAYER_SAVE_DIR)
	var save_files: PackedStringArray = dir.get_files()
	var saves: Array[PlayerData] = []
	for file_name in save_files:
		var player_data: PlayerData = PlayerSaveFileAccess.load(file_name)
		saves.append(player_data)
	return saves


static func save(player_name: String, data: PlayerData) -> void:
	var path = PLAYER_SAVE_DIR + player_name.to_lower()
	var file = FileAccess.open(path, FileAccess.WRITE_READ)

	if file:
		file.store_var(data.to_dict())
		file.close()
		Log.info("Player data saved successfully: %s" % data.to_dict())
		Log.debug(data.to_dict())
	else:
		Log.err("Failed to open file for saving: %s" % path)


static func load(player_name: String) -> PlayerData:
	var path = PLAYER_SAVE_DIR + player_name.to_lower()

	if not exists(player_name):
		Log.warn(
			"No player save file found for player: %s, returning default PlayerData" % player_name
		)
		return PlayerData.new()

	var file = FileAccess.open(path, FileAccess.READ)

	var player_data_dict: Dictionary = file.get_var()
	var player_data: PlayerData = PlayerData.from_dict(player_data_dict)
	file.close()

	if player_data == null:
		Log.warn("Loaded player data is null, returning default PlayerData")
		return PlayerData.new()

	return player_data


static func delete(player_name: String) -> bool:
	var path = PLAYER_SAVE_DIR + player_name.to_lower()
	var dir = DirAccess.open(PLAYER_SAVE_DIR)

	if exists(player_name):
		dir.remove(path)
		return true

	Log.warn("No player save file found to delete for player: %s" % player_name)
	return false
