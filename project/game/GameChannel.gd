extends Node

signal started
signal joining(data: GameData)
signal joined
signal paused(mode: Game.PauseMode)
signal quitting
signal quitted

signal saving_world(world: String)
signal saved_world(world: WorldData)
signal loading_world(world: String)
signal loaded_world(world: WorldData)

signal saving_player(data: String)
signal saved_player(player: PlayerData)
signal loading_player(player: String)
signal loaded_player(player: PlayerData)


func start(world: String, player: String) -> void:
	loading_world.emit(world)
	loading_player.emit(player)
	on_started()


func on_started() -> void:
	started.emit()


func join(data: GameData) -> void:
	joining.emit(data)


func on_joined() -> void:
	joined.emit()


func load_world(data: WorldData) -> void:
	loading_world.emit(data)


func on_world_loaded() -> void:
	loaded_world.emit()


func load_player(data: PlayerData) -> void:
	loading_player.emit(data)


func on_player_loaded() -> void:
	loaded_player.emit()


func save_player(player: String) -> void:
	saving_player.emit(player)


func on_player_saved(player: PlayerData) -> void:
	saved_player.emit(player)


func save_world(world: String) -> void:
	saving_world.emit(world)


func on_world_saved(world: WorldData) -> void:
	saved_world.emit(world)


func pause(mode: Game.PauseMode):
	paused.emit(mode)


func quit() -> void:
	quitting.emit()


func on_quitted() -> void:
	quitted.emit()
