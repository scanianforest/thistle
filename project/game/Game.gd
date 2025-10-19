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
	GameChannel.joining.connect(_on_game_joining)
	GameChannel.joined.connect(_on_game_joined)
	GameChannel.saving.connect(_on_game_saving)
	GameChannel.saved.connect(_on_game_saved)
	GameChannel.paused.connect(_on_game_paused)
	GameChannel.quitting.connect(_on_game_quitting)
	GameChannel.quitted.connect(_on_game_quitted)

func _on_game_starting(data: GameData) -> void:
	if data != null:
		_data = data

	Log.pr("starting, startup logic goes here!")
	GameChannel.on_started()

func _on_game_started() -> void:
	Log.pr("started")

func _on_game_joining(__data: GameData) -> void:
	GameChannel.joined.emit()

func _on_game_joined() -> void:
	Log.pr("Loaded save with metadata:", _data.metadata.to_dict())

func _on_game_saving(data: GameData) -> void:
	Log.pr("saving", data.to_dict())
	GameDataFileAccess.save(data.metadata.name, data)
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
