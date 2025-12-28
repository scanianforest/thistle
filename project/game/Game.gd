class_name Game extends CanvasLayer

enum PauseMode { PAUSED_BY_GAME, PAUSED_BY_PLAYER, UNPAUSED }

signal started
signal stopped

@onready var hsm: LimboHSM = $HSM
@onready var main_menu_state: Game_State_InMainMenu = $HSM/InMainMenu
@onready var starting_state: Game_State_Starting = $HSM/Starting
@onready var joining_state: Game_State_Joining = $HSM/Joining
@onready var ingame_state: Game_State_InGame = $HSM/InGame
@onready var quitting_state: Game_State_Quitting = $HSM/Quitting

@onready var world: World = %World
@onready var player_manager: PlayerManager = %PlayerManager
@onready var blackout: Blackout = %Blackout


func _ready() -> void:
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	_register_console_commands()

	WorldSaveFileAccess.create_world_save_directory()
	PlayerSaveFileAccess.create_player_save_directory()

	hsm.initial_state = main_menu_state

	hsm.active_state_changed.connect(
		func(new_state: LimboState, old_state: LimboState) -> void:
			Log.pr("Game HSM active state changed from %s to %s" % [old_state, new_state])
	)

	hsm.blackboard.bind_var_to_property("player_data", player_manager, "local_player_data", true)
	hsm.blackboard.bind_var_to_property("world_data", world, "data", true)

	hsm.add_transition(main_menu_state, starting_state, &"to_starting")
	hsm.add_transition(main_menu_state, joining_state, &"to_joining")
	hsm.add_transition(main_menu_state, quitting_state, &"to_quitting")

	hsm.add_transition(starting_state, ingame_state, &"to_ingame")
	hsm.add_transition(starting_state, main_menu_state, &"to_main_menu")

	hsm.add_transition(joining_state, ingame_state, &"to_ingame")
	hsm.add_transition(joining_state, main_menu_state, &"to_main_menu")

	hsm.add_transition(ingame_state, quitting_state, &"to_quitting")
	hsm.add_transition(ingame_state, main_menu_state, &"to_main_menu")

	hsm.initialize(self)
	hsm.set_active(true)

	hsm.add_event_handler(&"player_loaded", _on_player_data_loaded)
	hsm.add_event_handler(&"world_loaded", _on_world_data_loaded)
	hsm.add_event_handler(&"started", _on_started)
	hsm.add_event_handler(&"stopped", _on_stopped)
	hsm.add_event_handler(&"host", _on_host)
	hsm.add_event_handler(&"join", _on_join)
	hsm.add_event_handler(&"reveal", _on_reveal)


func ready_for_start() -> bool:
	Log.pr(
		(
			"Checking if ready for start: Player Data: %s, World Data: %s"
			% [player_manager.local_player_data != null, world.data != null]
		)
	)
	return player_manager.local_player_data != null and world.data != null


func start() -> void:
	await blackout.blackout()
	hsm.dispatch(&"to_starting")


func create_character(player_name: String) -> void:
	var data = PlayerData.new()
	data.metadata.name = player_name
	PlayerSaveFileAccess.save(player_name, data)


func create_world(world_name: String) -> void:
	world.create_new(world_name)


func load_player(player_name: String) -> void:
	hsm.dispatch(&"load_player", player_name)


func load_world(world_name: String) -> void:
	hsm.dispatch(&"load_world", world_name)


func _register_console_commands() -> void:
	LimboConsole.register_command(start, "game_start", "Starts a new game")
	(
		LimboConsole
		. register_command(
			join,
			"game_join",
			"Joins a multiplayer game at the specified IP and port",
		)
	)
	LimboConsole.register_command(
		quit_to_main_menu,
		"game_quit_to_menu",
		"Quits the current game and returns to the main menu"
	)
	LimboConsole.register_command(
		quit, "game_quit", "Quits the game and returns to the main menu or desktop"
	)


func _on_player_data_loaded(data: PlayerData) -> bool:
	player_manager.local_player_data = data
	Log.pr("Player data set: %s" % data.metadata.name)
	return true


func _on_world_data_loaded(data: WorldData) -> bool:
	world.data = data
	Log.pr("World data set: %s" % data.metadata.name)
	return true


func _on_host(dict: Dictionary) -> bool:
	var host_error = Lobby.host(dict.port, dict.max_clients)

	if host_error != OK:
		Log.err("Failed to host lobby: %s" % str(host_error))
		hsm.dispatch(&"to_main_menu")
	else:
		hsm.dispatch(&"hosted")

	return true


func _on_started() -> bool:
	start_game()
	return true


func _on_stopped() -> bool:
	stop_game()
	return true


func _on_reveal() -> bool:
	blackout.reveal()
	return true


func _load_world(world_data: WorldData) -> void:
	world.data = world_data


func _load_player(player_data: PlayerData) -> void:
	player_manager.local_player_data = player_data


func _on_join(ip_port_dict: Dictionary) -> bool:
	var ip: String = ip_port_dict.ip
	var port: int = ip_port_dict.port

	Lobby.join(ip, port)

	world.show()
	world.unpause()

	started.emit()
	return true


func start_game() -> void:
	world.show()
	world.unpause()

	started.emit()


func stop_game() -> void:
	world.pause()
	world.hide()
	world.clear()

	Lobby.leave()

	stopped.emit()


func join(ip: String, port: int = 7890) -> void:
	await blackout.blackout()
	hsm.blackboard.set_var("ip", ip)
	hsm.blackboard.set_var("port", port)
	hsm.dispatch(&"to_joining")


func quit(to_desktop: bool) -> void:
	await blackout.blackout()
	if to_desktop:
		hsm.dispatch(&"to_quitting")
	else:
		hsm.dispatch(&"to_main_menu")


func quit_to_main_menu() -> void:
	Log.pr("Quitting to main menu...")
	save()

	player_manager.despawn_player()
	world.unload()

	stopped.emit()


func _quit_to_desktop() -> void:
	Log.pr("Quitting game...")
	save()

	world.unload()

	get_tree().quit()


func save() -> void:
	Log.pr("saving game...")

	player_manager.save()

	if world.is_multiplayer_authority():
		world.save()


func _on_server_disconnected() -> void:
	quit(false)
