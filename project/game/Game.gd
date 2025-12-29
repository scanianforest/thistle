class_name Game extends CanvasLayer

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

	hsm.blackboard.bind_var_to_property("player_data", player_manager, "character_data", true)
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
	hsm.add_event_handler(&"reveal", _on_reveal)

	multiplayer.connected_to_server.connect(func() -> void: hsm.dispatch(&"connected_to_server"))
	multiplayer.connection_failed.connect(func() -> void: hsm.dispatch(&"connection_failed"))

	Lobby.set_lobby_player_name("Andreas")


func ready_for_start() -> bool:
	return player_manager.character_data != null and world.data != null


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
		quit, "game_quit", "Quits the game and returns to the main menu or desktop"
	)


func _on_player_data_loaded(data: PlayerData) -> bool:
	player_manager.character_data = data

	Log.info("Player data set: %s" % data.metadata.name)
	return true


func _on_world_data_loaded(data: WorldData) -> bool:
	world.data = data

	Log.info("World data set: %s" % data.metadata.name)
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


func start_game() -> void:
	world.show()
	world.unpause()
	world.load(world.data.metadata.name)

	started.emit()


func stop_game() -> void:
	world.pause()
	world.hide()
	world.clear()

	player_manager.save()

	Lobby.leave()

	stopped.emit()


func join(ip: String, port: int = 7890) -> void:
	await blackout.blackout()
	hsm.blackboard.set_var("ip", ip)
	hsm.blackboard.set_var("port", port)
	hsm.dispatch(&"to_joining")


func save() -> void:
	Log.info("Saving game...")
	player_manager.save()

	if world.is_multiplayer_authority():
		world.save()


func quit(to_desktop: bool, save_on_quit: bool = true) -> void:
	await blackout.blackout()
	if save_on_quit:
		save()

	if to_desktop:
		hsm.dispatch(&"to_quitting")
	else:
		hsm.dispatch(&"to_main_menu")


func _quit_to_desktop() -> void:
	get_tree().quit()


func _on_save() -> bool:
	return true


func _on_server_disconnected() -> void:
	save()
	quit(false)
