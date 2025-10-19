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


#region Inventory
signal inventory_item_added(item)
signal inventory_item_removed(item)
signal inventory_updated(items: Array[ItemResource])

func on_inventory_item_added(item) -> void:
	inventory_item_added.emit(item)
func on_inventory_item_removed(item) -> void:
	inventory_item_removed.emit(item)
func on_inventory_updated(items: Array[ItemResource]) -> void:
	inventory_updated.emit(items)
#endregion