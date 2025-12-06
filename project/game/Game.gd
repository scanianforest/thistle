class_name Game extends Node2D

enum PauseMode { PAUSED_BY_GAME, PAUSED_BY_PLAYER, UNPAUSED }

signal started
signal stopped

@onready var world: World = %World
@onready var player_manager: PlayerManager = %PlayerManager

var player_data: PlayerData
var world_data: WorldData


func _ready() -> void:
	WorldSaveFileAccess.create_world_save_directory()
	PlayerSaveFileAccess.create_player_save_directory()


func start_game() -> void:
	if player_data == null:
		Log.err("Cannot start game: player_data is null")
		return
	if world_data == null:
		Log.err("Cannot start game: world_data is null")

	world.data = world_data
	player_manager.local_player_data = player_data

	world.show()
	world.unpause()
	player_manager.spawn_local_player()

	started.emit()


func quit_to_main_menu() -> void:
	Log.pr("Quitting to main menu...")
	save()

	player_manager.despawn_player()
	world.unload()

	stopped.emit()


func quit_to_desktop() -> void:
	Log.pr("Quitting game...")
	save()

	world.unload()

	get_tree().quit()


func _on_player_set(data: PlayerData) -> void:
	player_data = data


func _on_world_set(data: WorldData) -> void:
	world_data = data


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


func save() -> void:
	Log.pr("saving game...")
	player_manager.save_local_player()
	world.save()
