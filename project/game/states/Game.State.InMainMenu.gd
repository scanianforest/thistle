class_name Game_State_InMainMenu extends LimboState


func _setup() -> void:
	add_event_handler(&"new_player", _on_new_player)
	add_event_handler(&"new_world", _on_new_world)
	add_event_handler(&"load_player", _on_load_player)
	add_event_handler(&"load_world", _on_load_world)


func _enter() -> void:
	dispatch(&"stopped")
	dispatch(&"reveal")


func _on_new_player(player_name: String) -> bool:
	var player_data = PlayerData.new()
	player_data.name = player_name
	SaveFileAccess.save(player_data)
	dispatch("player_created", player_data)
	return true


func _on_new_world(world_name: String) -> bool:
	var world_data = WorldData.new()
	world_data.name = world_name
	SaveFileAccess.save(world_data)
	dispatch("world_created", world_data)
	return true


func _on_load_player(player_name: String) -> bool:
	var player_data: PlayerData = SaveFileAccess.load(
		PlayerData.SAVE_DIR, player_name, PlayerData.from_dict
	)
	dispatch(&"player_loaded", player_data)
	return true


func _on_load_world(world_name: String) -> bool:
	var world_data = SaveFileAccess.load(WorldData.SAVE_DIR, world_name, WorldData.from_dict)
	dispatch(&"world_loaded", world_data)
	return true
