extends Control

@onready var _start_button: Button = %StartButton
@onready var _quit_button: Button = %QuitButton

@export var _game: Game

@onready var character_name_edit: LineEdit = %CharacterNameEdit
@onready var world_name_edit: LineEdit = %WorldNameEdit


func _ready() -> void:
	_start_button.pressed.connect(_on_start_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)

	character_name_edit.text_changed.connect(_on_character_name_edit_text_changed)
	world_name_edit.text_changed.connect(_on_world_name_edit_text_changed)

	_on_character_name_edit_text_changed(character_name_edit.text)
	_on_world_name_edit_text_changed(world_name_edit.text)


func _update_start_button_state() -> void:
	_start_button.disabled = _game.player_data == null or _game.world_data == null


func _on_character_name_edit_text_changed(new_text: String) -> void:
	if PlayerSaveFileAccess.exists(new_text):
		_game.player_data = PlayerSaveFileAccess.load(new_text)
	else:
		_game.player_data = PlayerData.new()
		_game.player_data.metadata.name = new_text
	_update_start_button_state()


func _on_world_name_edit_text_changed(new_text: String) -> void:
	if WorldSaveFileAccess.exists(new_text):
		_game.world_data = WorldSaveFileAccess.load(new_text)
	else:
		_game.world_data = WorldData.new()
		_game.world_data.metadata.name = new_text
	_update_start_button_state()


func _on_start_button_pressed() -> void:
	_game.start_game()
	hide()


func _on_quit_button_pressed() -> void:
	_game.quit_game()
