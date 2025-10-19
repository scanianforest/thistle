extends Node

signal starting(data: GameData)
signal started
signal joining(data: GameData)
signal joined
signal saving(data: GameData)
signal saved
signal paused(mode: Game.PauseMode)
signal quitting
signal quitted

func start(data: GameData) -> void:
	starting.emit(data)

func on_started() -> void:
	started.emit()

func join(data: GameData) -> void:
	joining.emit(data)

func on_joined() -> void:
	joined.emit()

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
