extends Control

@onready var _start_button: Button = %StartButton
@onready var _quit_button: Button = %QuitButton

@export var _game: Game

@onready var world_name_edit: LineEdit = %WorldNameEdit

@onready var join_edit: LineEdit = %JoinEdit
@onready var join_button: Button = %JoinButton

@onready var character_name_edit: LineEdit = %CharacterNameEdit
@onready var create_character_button: Button = %CreateCharacterButton
@onready var characters: ItemList = %CharacterList
@onready var worlds: ItemList = %WorldList
@onready var create_world_button: Button = %CreateWorldButton


func _ready() -> void:
	_game.started.connect(hide)
	_game.stopped.connect(show)

	_start_button.pressed.connect(_on_start_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)

	join_button.pressed.connect(_on_join_button_pressed)

	characters.item_selected.connect(_on_character_selected)
	worlds.item_selected.connect(_on_world_selected)

	create_character_button.pressed.connect(_on_create_character_button_pressed)
	create_world_button.pressed.connect(_on_create_world_button_pressed)

	_refresh_character_list()
	_refresh_world_list()


func _refresh_character_list() -> void:
	characters.clear()
	var chars = PlayerSaveFileAccess.get_saves()
	chars.sort_custom(func(a, b): return a.metadata.last_loaded > b.metadata.last_loaded)
	for character in chars:
		characters.add_item(character.metadata.name)


func _refresh_world_list() -> void:
	worlds.clear()
	var ws = WorldSaveFileAccess.get_saves()
	ws.sort_custom(func(a, b): return a.metadata.last_loaded > b.metadata.last_loaded)
	for world in ws:
		worlds.add_item(world.metadata.name)


func _on_character_selected(index: int) -> void:
	var character_name: String = characters.get_item_text(index)
	_game.load_player(character_name)
	_start_button.disabled = not _game.ready_for_start()


func _on_world_selected(index: int) -> void:
	var world_name: String = worlds.get_item_text(index)
	_game.load_world(world_name)
	_start_button.disabled = not _game.ready_for_start()


func _on_create_character_button_pressed() -> void:
	var character_name: String = character_name_edit.text
	_game.create_character(character_name)
	_refresh_character_list()


func _on_create_world_button_pressed() -> void:
	var world_name: String = world_name_edit.text
	_game.create_world(world_name)
	_refresh_world_list()


func _update_start_button_state() -> void:
	_start_button.disabled = (
		_game.player_manager.local_player_data == null or _game.world.data == null
	)


func _on_start_button_pressed() -> void:
	_game.start()
	hide()


func _on_join_button_pressed() -> void:
	var address: String = join_edit.text

	var address_parts: Array = address.split(":")
	var ip: String = address_parts[0]

	_game.join(ip)


func _on_quit_button_pressed() -> void:
	_game.quit(true)
