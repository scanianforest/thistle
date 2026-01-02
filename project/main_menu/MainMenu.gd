extends Control

@onready var _start_button: Button = %StartButton
@onready var _quit_button: Button = %QuitButton

@export var _game: Game

@onready var join_edit: LineEdit = %JoinEdit
@onready var join_button: Button = %JoinButton


func _ready() -> void:
	_game.started.connect(hide)
	_game.stopped.connect(show)

	_start_button.pressed.connect(_on_start_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)

	join_button.pressed.connect(_on_join_button_pressed)


func _on_character_data_selected(data: PlayerData) -> void:
	_game.load_player(data.metadata.name)
	_start_button.disabled = not _game.ready_for_start()


func _on_world_data_selected(data: WorldData) -> void:
	_game.load_world(data.metadata.name)
	_start_button.disabled = not _game.ready_for_start()


func _update_start_button_state() -> void:
	_start_button.disabled = (
		_game.player_manager.character_data == null or _game.world_node.data == null
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
