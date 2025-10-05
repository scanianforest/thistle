extends Node

signal spawned(global_position: Vector2)
signal despawned
signal possessed(pawn: Pawn2D)
signal unpossessed

signal health_changed(new_health: int)
signal max_health_changed(new_max_health: int)
signal died

func spawn(global_position: Vector2) -> void:
	spawned.emit(global_position)

func despawn() -> void:
	despawned.emit()

func possess(pawn: Pawn2D) -> void:
	possessed.emit(pawn)

func unpossess() -> void:
	unpossessed.emit()

func broadcast_health_changed(new_health: int) -> void:
	health_changed.emit(new_health)

func broadcast_max_health_changed(new_max_health: int) -> void:
	max_health_changed.emit(new_max_health)

func broadcast_died() -> void:
	died.emit()
