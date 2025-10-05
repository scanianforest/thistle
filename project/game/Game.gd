class_name Game extends Node2D

enum PauseMode {
	PAUSED_BY_GAME,
	PAUSED_BY_PLAYER,
	UNPAUSED
}

var _data: GameData = GameData.new()

func _ready() -> void:
	GameChannel.starting.connect(_on_game_starting)
	GameChannel.started.connect(_on_game_started)
	GameChannel.loading.connect(_on_game_loading)
	GameChannel.loaded.connect(_on_game_loaded)
	GameChannel.saving.connect(_on_game_saving)
	GameChannel.saved.connect(_on_game_saved)
	GameChannel.paused.connect(_on_game_paused)
	GameChannel.quitting.connect(_on_game_quitting)
	GameChannel.quitted.connect(_on_game_quitted)

	GameDataFileAccess.create_default_save()

func _on_game_starting() -> void:
	Log.pr("starting, startup logic goes here!")
	GameChannel.on_started()

func _on_game_started() -> void:
	Log.pr("started")

func _on_game_loading(__data: GameData) -> void:
	GameChannel.loaded.emit()

func _on_game_loaded() -> void:
	Log.pr("Loaded save with metadata:", _data.metadata.to_dict())

func _on_game_saving(data: GameData) -> void:
	Log.pr("saving", data.to_dict())
	GameDataFileAccess.save("res://saves/default.sav", data)
	GameChannel.saved.emit()

func _on_game_saved() -> void:
	Log.pr("saved", _data.metadata.name)

func _on_game_paused() -> void:
	Log.pr("paused")

func _on_game_quitting() -> void:
	Log.pr("autosaving before quit")
	GameChannel.save(_data)
	GameChannel.on_quitted()

func _on_game_quitted() -> void:
	Log.pr("quitting game")
	get_tree().quit()



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		GameChannel.quit()
