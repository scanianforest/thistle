extends Node

signal starting
signal started
signal loading(data: GameData)
signal loaded
signal saving(data: GameData)
signal saved
signal paused(mode: Game.PauseMode)
signal quitting
signal quitted

func start() -> void:
	starting.emit()

func on_started() -> void:
	started.emit()

func load(data: GameData) -> void:
	loading.emit(data)

func on_loaded() -> void:
	loaded.emit()

func save(data: GameData) -> void:
	saving.emit(data)

func on_saved() -> void:
	saved.emit()

func pause(mode: Game.PauseMode):
	paused.emit(mode)

func quit() -> void:
	quitting.emit()

func on_quitted() -> void:
	quitted.emit()
