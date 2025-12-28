class_name WorldSaveFileAccess

const WORLD_SAVE_DIR = "user://saves/worlds/"


static func create_world_save_directory() -> void:
	var dir = DirAccess.make_dir_absolute(WORLD_SAVE_DIR)
	if dir == null:
		Log.err("Failed to create world saves directory")


static func exists(world_name: String) -> bool:
	var path = WORLD_SAVE_DIR + world_name.to_lower()
	return FileAccess.file_exists(path)


static func save(world_name: String, data: WorldData) -> void:
	var path = WORLD_SAVE_DIR + world_name.to_lower()
	var file = FileAccess.open(path, FileAccess.WRITE_READ)
	if file:
		file.store_var(data.to_dict())
		file.close()
		Log.debug("World data saved successfully to %s" % path)
	else:
		Log.err("Failed to open file for saving: %s" % path)


static func load(world_name: String) -> WorldData:
	var path = WORLD_SAVE_DIR + world_name.to_lower()

	if not exists(world_name):
		Log.warn("World save file does not exist for world: %s" % world_name)
		return null

	var file = FileAccess.open(path, FileAccess.READ)

	var world_data_dict: Dictionary = file.get_var()
	var world_data: WorldData = WorldData.from_dict(world_data_dict)
	file.close()

	Log.debug("World data loaded successfully from %s" % path)

	return world_data


static func delete(world_name: String) -> bool:
	var path = WORLD_SAVE_DIR + world_name.to_lower()
	var dir = DirAccess.open(WORLD_SAVE_DIR)
	if exists(world_name):
		dir.remove(path)
		return true
	else:
		Log.warn("Cannot delete non-existent world save: %s" % world_name)
		return false


static func get_saves() -> Array[WorldData]:
	var dir = DirAccess.open(WORLD_SAVE_DIR)
	var files = dir.get_files()

	var saves: Array[WorldData] = []
	for file_name in files:
		var world_name = file_name
		var world_data = WorldSaveFileAccess.load(world_name)
		if world_data != null:
			saves.append(world_data)
	return saves
