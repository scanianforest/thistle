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

	_refresh_character_list.call_deferred()


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
		Log.pr(save)
		character_option_button.add_item(save.name)

	delete_character_button.disabled = character_option_button.get_item_count() == 0


func _on_new_character_name_input_changed(new_text: String) -> void:
	new_character_button.disabled = not _is_new_character_name_valid(new_text)


func _on_character_selected(index: int) -> void:
	delete_character_button.disabled = index == -1
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


func _on_delete_character_button_pressed() -> void:
	var selected_index: int = character_option_button.get_selected()
	if selected_index == -1:
		return
	var selected_name: String = character_option_button.get_item_text(selected_index)

	if PlayerSaveFileAccess.delete(selected_name):
		_refresh_character_list()
