extends Node

signal spawned(global_position: Vector2)
signal despawned
signal possessed(pawn: Pawn2D)
signal unpossessed

signal health_changed(new_health: int)
signal max_health_changed(new_max_health: int)
signal died

#region Player Lifecycle
func spawn(global_position: Vector2) -> void:
	spawned.emit(global_position)

func despawn() -> void:
	despawned.emit()

func possess(pawn: Pawn2D) -> void:
	possessed.emit(pawn)

func unpossess() -> void:
	unpossessed.emit()
#endregion

#region Health
func broadcast_health_changed(new_health: int) -> void:
	health_changed.emit(new_health)

func broadcast_max_health_changed(new_max_health: int) -> void:
	max_health_changed.emit(new_max_health)

func broadcast_died() -> void:
	died.emit()
#endregion

#region Inventory
signal inventory_item_added(item: Item)
signal inventory_item_removed(item: Item)
signal inventory_updated(items: Array[Item])

func on_inventory_item_added(item) -> void:
	inventory_item_added.emit(item)
func on_inventory_item_removed(item) -> void:
	inventory_item_removed.emit(item)
func on_inventory_updated(items: Array[Item]) -> void:
	inventory_updated.emit(items)
#endregion

#region Action Bar
signal action_bar_slot_selection_requested(index: int)
signal action_bar_slot_selected(index: int)
signal action_bar_slot_update_requested(index: int, item: Item)
signal action_bar_slot_updated(index: int, item: Item)


func on_action_bar_slot_selection_requested(index: int) -> void:
	action_bar_slot_selection_requested.emit(index)
func on_action_bar_slot_selected(index: int) -> void:
	action_bar_slot_selected.emit(index)
func on_action_bar_slot_update_requested(index: int, item: Item) -> void:
	action_bar_slot_update_requested.emit(index, item)
func on_action_bar_slot_updated(index: int, item: Item) -> void:
	action_bar_slot_updated.emit(index, item)
#endregion