class_name Game_State_InMainMenu extends LimboState


func _setup() -> void:
	add_event_handler(&"new_character", _on_new_character)
	add_event_handler(&"new_world", _on_new_world)
	add_event_handler(&"load_character", _on_load_character)
	add_event_handler(&"load_world", _on_load_world)


func _enter() -> void:
	dispatch(&"stopped")
	dispatch(&"reveal")


func _on_new_character(character_name: String) -> bool:
	var character_data = CharacterData.new()
	character_data.name = character_name

	SaveFileAccess.save(character_data)

	dispatch("player_created", character_data)
	return true


func _on_new_world(world_name: String) -> bool:
	var world_data = WorldData.new()
	world_data.name = world_name

	SaveFileAccess.save(world_data)

	dispatch("world_created", world_data)
	return true


func _on_load_character(character_name: String) -> bool:
	var character_data: CharacterData = SaveFileAccess.load(
		CharacterData.SAVE_DIR, character_name, CharacterData.from_dict
	)

	dispatch(&"player_loaded", character_data)
	return true


func _on_load_world(world_name: String) -> bool:
	var world_data = SaveFileAccess.load(WorldData.SAVE_DIR, world_name, WorldData.from_dict)

	dispatch(&"world_loaded", world_data)
	return true
