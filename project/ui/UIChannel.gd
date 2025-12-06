extends Node

signal player_set(player: Player)
signal inventory_set(inventory: InventoryComponent)
signal actionbar_set(action_bar: ActionBarComponent)
signal container_opened(inventory: InventoryComponent)
signal container_closed
signal input_event(event: InputEvent)
signal pause_menu_opened


func set_player(player: Player) -> void:
	player_set.emit(player)


func set_inventory(inventory: InventoryComponent) -> void:
	inventory_set.emit(inventory)


func set_actionbar(action_bar: ActionBarComponent) -> void:
	actionbar_set.emit(action_bar)


func open_container(inventory: InventoryComponent) -> void:
	container_opened.emit(inventory)


func close_container() -> void:
	container_closed.emit()


func on_input_event(event: InputEvent) -> void:
	input_event.emit(event)


func open_pause_menu() -> void:
	pause_menu_opened.emit()
