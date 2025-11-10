class_name CharacterSelectionPanel extends SelectionPanel


func _get_options() -> Array[String]:
	return PlayerSaveFileAccess.get_save_names()


func _get_option_data(text: String) -> Variant:
	return PlayerSaveFileAccess.load(text)


func _on_create_option(text: String) -> void:
	var player_name: String = text.strip_edges()
	var player_data: PlayerData = PlayerData.new()
	player_data.metadata.name = player_name
	PlayerSaveFileAccess.save(player_name, player_data)


func _on_delete_option(index: int) -> void:
	var player_name: String = options_button.get_item_text(index)
	PlayerSaveFileAccess.delete(player_name)
