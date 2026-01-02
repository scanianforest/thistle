class_name SaveFileAccess


static func _ensure_dir(dir_path) -> void:
	if DirAccess.dir_exists_absolute(dir_path):
		return

	var dir = DirAccess.make_dir_absolute(dir_path)
	if dir == null:
		Log.err("Failed to create directory %s" % dir_path)


static func exists(data: SaveData) -> bool:
	var path = data.get_save_path()
	return FileAccess.file_exists(path)


static func get_saves(dir_name: String, from_dict: Callable) -> Array[SaveData]:
	_ensure_dir(dir_name)

	var saves: Array[SaveData] = []

	for file_name in DirAccess.get_files_at(dir_name):
		var player_data: SaveData = SaveFileAccess.load(dir_name, file_name, from_dict)
		saves.append(player_data)

	return saves


static func save(data: SaveData) -> void:
	_ensure_dir(data.SAVE_DIR)

	var path = data.get_save_path()
	var file = FileAccess.open(path, FileAccess.WRITE_READ)

	if file:
		file.store_var(data.to_dict())
		file.close()
		Log.info("Player data saved successfully: %s" % data.to_dict())
		Log.debug(data.to_dict())
	else:
		Log.err("Failed to open file for saving: %s" % path)


static func load(dir: String, name: String, from_dict: Callable) -> SaveData:
	_ensure_dir(dir)

	var path = dir + name.to_lower()

	var file = FileAccess.open(path, FileAccess.READ)

	if not file:
		Log.err("Failed to open file for loading: %s" % path)
		return null

	var data_dict: Dictionary = file.get_var()
	var data: SaveData = from_dict.call(data_dict)

	file.close()

	return data


static func delete(data: SaveData) -> bool:
	var path = data.get_save_path()

	if not exists(data):
		Log.warn("No save file found at path: %s" % path)
		return false

	DirAccess.remove_absolute(path)
	return true
