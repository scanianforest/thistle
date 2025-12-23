class_name Game extends Node2D

enum PauseMode { PAUSED_BY_GAME, PAUSED_BY_PLAYER, UNPAUSED }

signal started
signal stopped

@onready var hsm: LimboHSM = $HSM
@onready var main_menu_state: Game_State_InMainMenu = $HSM/InMainMenu
@onready var starting_state: Game_State_Starting = $HSM/Starting
@onready var joining_state: Game_State_Joining = $HSM/Joining
@onready var running_state: Game_State_Running = $HSM/Running
@onready var quitting_state: Game_State_Quitting = $HSM/Quitting

@onready var world: World = %World
@onready var player_manager: PlayerManager = %PlayerManager
@onready var network_manager: NetworkManager = %NetworkManager
@onready var blackout: Blackout = %Blackout


func _ready() -> void:
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

	hsm.add_transition(starting_state, running_state, &"to_running")
	hsm.add_transition(starting_state, main_menu_state, &"to_main_menu")

	hsm.add_transition(joining_state, running_state, &"to_running")
	hsm.add_transition(joining_state, main_menu_state, &"to_main_menu")

	hsm.add_transition(running_state, quitting_state, &"to_quitting")

	hsm.add_transition(quitting_state, main_menu_state, &"to_main_menu")

	hsm.initialize(self)
	hsm.set_active(true)

	hsm.add_event_handler(&"player_data_set", _on_player_data_set)
	hsm.add_event_handler(&"world_data_set", _on_world_data_set)
	hsm.add_event_handler(&"started", _on_started)
	hsm.add_event_handler(&"host", _on_host)
	hsm.add_event_handler(&"reveal", _on_reveal)


func start() -> void:
	await blackout.blackout()
	hsm.dispatch(&"to_starting")


func create_character(player_name: String) -> void:
	var data = PlayerData.new()
	data.metadata.name = player_name
	PlayerSaveFileAccess.save(player_name, data)


func create_world(world_name: String) -> void:
	var data = WorldData.new()
	data.metadata.name = world_name
	WorldSaveFileAccess.save(world_name, data)


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


func _on_player_data_set(data: PlayerData) -> void:
	player_manager.local_player_data = data


func _on_world_data_set(data: WorldData) -> void:
	world.data = data


func _on_host(ip_port_dict: Dictionary) -> void:
	network_manager.host(ip_port_dict.ip, ip_port_dict.port)


func _on_started() -> bool:
	started.emit()
	return true


func _on_reveal() -> bool:
	blackout.reveal()
	return true


func _load_world(world_data: WorldData) -> void:
	world.data = world_data


func _load_player(player_data: PlayerData) -> void:
	player_manager.local_player_data = player_data


func start_game() -> void:
	network_manager.host()

	world.show()
	world.unpause()
	player_manager.spawn_local_player()

	started.emit()


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

	player_manager.save_local_player()

	if multiplayer.is_server():
		world.save()
