class_name Game extends Node2D

enum PauseMode { PAUSED_BY_GAME, PAUSED_BY_PLAYER, UNPAUSED }

@onready var world: World = %World
@onready var player_manager: PlayerManager = %PlayerManager

var player_data: PlayerData
var world_data: WorldData


func _ready() -> void:
	WorldSaveFileAccess.create_world_save_directory()
	PlayerSaveFileAccess.create_player_save_directory()

	GameChannel.started.connect(_on_game_started)
	GameChannel.joining.connect(_on_game_joining)
	GameChannel.paused.connect(_on_game_paused)
	GameChannel.quitting.connect(_on_game_quitting)
	GameChannel.quitted.connect(_on_game_quitted)

	# new
	GameChannel.saving_player.connect(_on_saving_player)
	GameChannel.saved_player.connect(_on_saved_player)
	GameChannel.saving_world.connect(_on_saving_world)
	GameChannel.saved_world.connect(_on_saved_world)
	GameChannel.loaded_player.connect(_on_loaded_player)
	GameChannel.loading_world.connect(_on_loading_world)
	GameChannel.loaded_world.connect(_on_loaded_world)


func start_game() -> void:
	if player_data == null:
		Log.err("Cannot start game: player_data is null")
		return
	if world_data == null:
		Log.err("Cannot start game: world_data is null")

	world.data = world_data
	player_manager.local_player_data = player_data


func quit_game() -> void:
	Log.pr("Quitting game...")
	get_tree().quit()


func _on_player_set(data: PlayerData) -> void:
	player_data = data
	if _is_player_and_world_set():
		GameChannel.on_joined()


func _on_world_set(data: WorldData) -> void:
	world_data = data


func _is_player_and_world_set() -> bool:
	return player_data != null and world_data != null


func _on_game_started() -> void:
	Log.pr("started")


func _on_game_joining(__data: GameData) -> void:
	GameChannel.joined.emit()


func _on_saving_player(data: PlayerData) -> void:
	Log.pr("saving player", data.to_dict())
	player_manager.save_local_player()
	GameChannel.saved_player.emit()


func _on_saving_world(data: WorldData) -> void:
	Log.pr("saving world", data.to_dict())
	world.save()
	GameChannel.saved_world.emit()


func _on_saved_player() -> void:
	Log.pr("player saved")


func _on_saved_world() -> void:
	Log.pr("world saved")


func _on_loaded_player(data: PlayerData) -> void:
	Log.pr("player loaded", data.metadata.to_dict())


func _on_loading_world(world_name: String) -> void:
	world.load_existing(world_name)


func _on_loaded_world(data: WorldData) -> void:
	Log.pr("world loaded", data.metadata.to_dict())


func _on_game_saving(data: GameData) -> void:
	Log.pr("saving", data.to_dict())
	GameDataFileAccess.save(data.metadata.name, data)
	GameChannel.saved.emit()


func _on_game_paused() -> void:
	Log.pr("paused")


func _on_game_quitting() -> void:
	Log.pr("autosaving before quit")
	player_manager.save_local_player()
	world.save()
	quit_game()


func _on_game_quitted() -> void:
	quit_game()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameChannel.quit()
