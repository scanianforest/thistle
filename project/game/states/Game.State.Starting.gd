class_name Game_State_Starting extends LimboState


func _setup() -> void:
	add_event_handler(&"hosted", _on_hosted)


func _enter() -> void:
	var player_data = blackboard.get_var("player_data") as PlayerData
	var world_data = blackboard.get_var("world_data") as WorldData

	if player_data == null or world_data == null:
		dispatch(&"to_main_menu")
		return

	dispatch(&"host", {"port": 7890, "max_clients": 32})


func _on_hosted() -> bool:
	Log.pr("Server hosted successfully.")
	dispatch(&"to_ingame")
	return true
