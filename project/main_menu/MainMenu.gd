extends Control

@onready var _quit_button: Button = %QuitButton

@onready var _character_selection_panel: CharacterSelectionPanel = %CharacterSelectionPanel
@onready var _world_selection_panel: WorldSelectionPanel = %WorldSelectionPanel


func _ready() -> void:
	GameChannel.started.connect(_on_game_started)
	GameChannel.joined.connect(_on_game_loaded)

	_quit_button.pressed.connect(_on_quit_button_pressed)


func _on_game_started() -> void:
	hide()


func _on_game_loaded() -> void:
	hide()


func _on_join_button_pressed() -> void:
	Log.pr("todo implement")
	# GameChannel.join(GameDataFileAccess.load(GameDataFileAccess.DEFAULT_SAVE_PATH))


func _on_quit_button_pressed() -> void:
	GameChannel.quit()
