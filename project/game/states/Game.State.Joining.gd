class_name Game_State_Joining extends LimboState


func _enter() -> void:
	var port = blackboard.get_var("port", 7890)
	var address = blackboard.get_var("ip", "127.0.0.1")

	Log.pr("Joining game session at %s:%d..." % [address, port])

	var player_data: PlayerData = blackboard.get_var("player_data")

	if player_data == null:
		Log.err("No player data found in blackboard!")
		dispatch(&"to_main_menu")
		return

	dispatch(&"join", {"ip": address, "port": port})
	dispatch(&"to_ingame")
