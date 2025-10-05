extends Control

@onready var _new_game_button: Button = %NewGameButton
@onready var _load_game_button: Button = %LoadGameButton
@onready var _quit_button: Button = %QuitButton

func _ready() -> void:
	GameChannel.started.connect(_on_game_started)
	GameChannel.loaded.connect(_on_game_loaded)

	_new_game_button.pressed.connect(_on_new_game_button_pressed)
	_load_game_button.pressed.connect(_on_load_game_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)

func _on_game_started() -> void: hide()
func _on_game_loaded() -> void: hide()

func _on_new_game_button_pressed() -> void:
	GameChannel.start()

func _on_load_game_button_pressed() -> void:
	GameChannel.load(GameDataFileAccess.load(GameDataFileAccess.DEFAULT_SAVE_PATH))

func _on_quit_button_pressed() -> void:
	GameChannel.quit()