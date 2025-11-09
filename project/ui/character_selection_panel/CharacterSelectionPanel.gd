class_name CharacterSelectionPanel extends PanelContainer

signal character_selected(data: PlayerData)

@onready var character_option_button: OptionButton = %CharacterOptionButton
@onready var new_character_name_input: LineEdit = %NewCharacterNameInput
@onready var new_character_button: Button = %NewCharacterButton
@onready var delete_character_button: Button = %DeleteCharacterButton


func _ready() -> void:
	character_option_button.item_selected.connect(_on_character_selected)

	new_character_name_input.text_changed.connect(_on_new_character_name_input_changed)
	new_character_name_input.text_submitted.connect(_on_new_character_name_input_submitted)

	new_character_button.pressed.connect(_on_new_character_button_pressed)

	delete_character_button.pressed.connect(_on_delete_character_button_pressed)

	_ready_deferred.call_deferred()


func _ready_deferred() -> void:
	_refresh_character_list()
	if character_option_button.get_item_count() > 0:
		var player_data = PlayerSaveFileAccess.load(character_option_button.get_item_text(0))
		character_selected.emit(player_data)


func _is_new_character_name_valid(character_name: String) -> bool:
	if character_name.strip_edges() == "":
		return false
	if PlayerSaveFileAccess.exists(character_name):
		return false
	return true


func _refresh_character_list() -> void:
	character_option_button.clear()
	var saves: Array[PlayerData] = PlayerSaveFileAccess.get_saves().filter(
		func(save: PlayerData) -> bool: return save != null
	)

	for save in saves:
		character_option_button.add_item(save.name)

	delete_character_button.disabled = character_option_button.get_item_count() == 0


func _select_by_name(character_name: String) -> void:
	for i in range(character_option_button.get_item_count()):
		if character_option_button.get_item_text(i) == character_name:
			character_option_button.select(i)
			return


func _on_new_character_name_input_changed(new_text: String) -> void:
	new_character_button.disabled = not _is_new_character_name_valid(new_text)


func _on_character_selected(index: int) -> void:
	delete_character_button.disabled = index == -1

	if index == -1:
		character_selected.emit(null)
		Log.pr("No character selected")
	else:
		var selected_name: String = character_option_button.get_item_text(index)
		var player_data: PlayerData = PlayerSaveFileAccess.load(selected_name)
		character_selected.emit(player_data)
		Log.pr("Selected character:", player_data.name)


func _on_new_character_name_input_submitted(_new_text: String) -> void:
	_on_new_character_button_pressed()


func _on_new_character_button_pressed() -> void:
	var new_name: String = new_character_name_input.text.strip_edges()

	var player_data: PlayerData = PlayerData.new()
	player_data.metadata.name = new_name

	PlayerSaveFileAccess.save(new_name, player_data)
	new_character_name_input.text = ""
	_on_new_character_name_input_changed("")
	_refresh_character_list()

	_select_by_name(new_name)
	_on_character_selected(character_option_button.selected)


func _on_delete_character_button_pressed() -> void:
	var selected_index: int = character_option_button.get_selected()
	var selected_name: String = character_option_button.get_item_text(selected_index)

	if PlayerSaveFileAccess.delete(selected_name):
		_refresh_character_list()
		Log.pr("Deleted character:", selected_name)
		_on_character_selected(character_option_button.selected)
