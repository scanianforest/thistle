class_name Game extends CanvasLayer

signal started
signal stopped

@export_group("Nodes")

@export_subgroup("Managers")
@export var player_manager: PlayerManager
@export var world_node: Node
@export var blackout: Blackout

@export_subgroup("States")
@export var hsm: LimboHSM
@export var main_menu_state: LimboState
@export var starting_state: LimboState
@export var joining_state: LimboState
@export var ingame_state: LimboState
@export var quitting_state: LimboState

var world: WorldComponent


func _enter_tree() -> void:
	_register_console_commands()


func _ready() -> void:
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	if not world_node.has_node("WorldComponent"):
		Log.err("World node does not have a WorldComponent child node")
		return

	world = world_node.get_node("WorldComponent")

	hsm.initial_state = main_menu_state

	hsm.blackboard.bind_var_to_property("player_data", player_manager, "character_data", true)
	hsm.blackboard.bind_var_to_property("world_data", world_node, "data", true)

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
	return player_manager.character_data != null and world_node.data != null


func start() -> void:
	await blackout.blackout()
	hsm.dispatch(&"to_starting")


func create_character(player_name: String) -> void:
	var data = PlayerData.new()
	data.metadata.name = player_name
	SaveFileAccess.save(data)


func create_world(world_name: String) -> void:
	world_node.create_new(world_name)


func load_player(player_name: String) -> void:
	hsm.dispatch(&"load_player", player_name)


func load_world(world_name: String) -> void:
	hsm.dispatch(&"load_world", world_name)


func start_game() -> void:
	world_node.show()
	world_node.unpause()

	started.emit()


func stop_game() -> void:
	world_node.pause()
	world_node.hide()
	world_node.clear()

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

	if world_node.is_multiplayer_authority():
		world_node.save()


func quit(to_desktop: bool, save_on_quit: bool = true) -> void:
	await blackout.blackout()

	if save_on_quit:
		save()

	if to_desktop:
		hsm.dispatch(&"to_quitting")
	else:
		hsm.dispatch(&"to_main_menu")


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
	world_node.data = data

	Log.info("TopDownWorld2D data set: %s" % data.metadata.name)
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


func _on_server_disconnected() -> void:
	quit(false)
