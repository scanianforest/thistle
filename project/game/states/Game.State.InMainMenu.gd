class_name Game_State_InMainMenu extends LimboState


func _setup() -> void:
	add_event_handler(&"load_character", _on_load_character)
	add_event_handler(&"load_world", _on_load_world)


func _enter() -> void:
	dispatch(&"stopped")
	dispatch(&"reveal")


func _on_load_character(data: SaveData) -> bool:
	dispatch(&"player_loaded", data)
	return true


func _on_load_world(data: SaveData) -> bool:
	dispatch(&"world_loaded", data)
	return true
