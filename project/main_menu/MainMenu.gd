extends Control

@onready var _start_button: Button = %StartButton
@onready var _quit_button: Button = %QuitButton

@onready var _character_selection_panel: CharacterSelectionPanel = %CharacterSelectionPanel
@onready var _world_selection_panel: WorldSelectionPanel = %WorldSelectionPanel

@export var _game: Game


func _ready() -> void:
	_character_selection_panel.character_selected.connect(_on_character_selected)
	_world_selection_panel.world_selected.connect(_on_world_selected)

	_quit_button.pressed.connect(_on_quit_button_pressed)


func _on_character_selected(player_data: PlayerData) -> void:
	_game.player_data = player_data
	_start_button.disabled = _is_start_disabled()

	if player_data:
		Log.pr("Selected character:", player_data.metadata.name)
	else:
		Log.pr("No character selected")


func _on_world_selected(world_data: WorldData) -> void:
	_game.world_data = world_data
	Log.pr("Selected world:", world_data.metadata.name)
	_start_button.disabled = _is_start_disabled()


func _is_start_disabled() -> bool:
	return not (_game.player_data and _game.world_data)


func _on_quit_button_pressed() -> void:
	GameChannel.quit()
