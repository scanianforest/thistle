class_name Game_State_Starting extends LimboState


func _enter() -> void:
	var player_data = blackboard.get_var("player_data") as PlayerData
	var world_data = blackboard.get_var("world_data") as WorldData

	if player_data == null or world_data == null:
		dispatch(&"to_main_menu")
		return

	var host_error = Lobby.host(7890, 32)

	if host_error == OK:
		dispatch(&"to_ingame")
	else:
		Log.err("Failed to host lobby: %s" % str(host_error))
		dispatch(&"to_main_menu")
