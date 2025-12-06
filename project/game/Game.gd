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


func save() -> void:
	Log.pr("saving game...")
	player_manager.save_local_player()
	world.save()
