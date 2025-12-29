class_name Game_State_Joining extends LimboState


func _setup() -> void:
	add_event_handler(&"connected_to_server", _on_connected_to_server)
	add_event_handler(&"connection_failed", _on_connection_failed)


func _enter() -> void:
	var port = blackboard.get_var("port", 7890)
	var address = blackboard.get_var("ip", "127.0.0.1")

	var player_data: PlayerData = blackboard.get_var("player_data")

	if player_data == null:
		Log.err("No player data found in blackboard!")
		dispatch(&"to_main_menu")
		return

	var join_error = Lobby.join(address, port)

	if join_error != OK:
		Log.err("Failed to join lobby at %s:%d" % [address, port])
		dispatch(&"to_main_menu")
		return


func _on_connected_to_server() -> bool:
	dispatch(&"to_ingame")
	return true


func _on_connection_failed() -> bool:
	Log.err("Connection to server failed")
	dispatch(&"to_main_menu")
	return true
