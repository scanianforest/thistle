class_name Game_State_Joining extends LimboState


func _enter() -> void:
	var port = blackboard.get_var("port", 7890)
	var address = blackboard.get_var("ip", "127.0.0.1")

	Log.pr("Joining game session at %s:%d..." % [address, port])

	get_tree().create_timer(1.0).timeout.connect(
		func() -> void:
			dispatch(&"error_occurred", "Failed to join the game session.")
			dispatch(&"to_main_menu")
	)
