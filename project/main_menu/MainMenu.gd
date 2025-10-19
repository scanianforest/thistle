extends Control

@onready var _start_button: Button = %StartButton
@onready var _join_button: Button = %JoinButton
@onready var _quit_button: Button = %QuitButton
@onready var _world_name_input: LineEdit = %WorldNameInput

func _ready() -> void:
	GameChannel.started.connect(_on_game_started)
	GameChannel.joined.connect(_on_game_loaded)

	_start_button.pressed.connect(_on_start_button_pressed)
	_join_button.pressed.connect(_on_join_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)

	_world_name_input.focus_exited.connect(func(): _world_name_input.text_submitted.emit(_world_name_input.text))
	_world_name_input.text_submitted.connect(_on_world_name_submitted)

	_start_button.text = "CREATE" if not GameDataFileAccess.save_exists(_world_name_input.text) else "CONTINUE"

func _on_game_started() -> void: hide()
func _on_game_loaded() -> void: hide()

func _on_start_button_pressed() -> void:
	var data = GameData.from_dict({})
	data.metadata.name = _world_name_input.text
	
	if GameDataFileAccess.save_exists(_world_name_input.text):
		data = GameDataFileAccess.load(_world_name_input.text)
		Log.pr("Continuing save: ", data.to_dict())
	else:
		Log.pr("Creating new save with name: ", data.metadata.name)
	
	GameChannel.start(data)

func _on_join_button_pressed() -> void:
	Log.pr("todo implement")
	# GameChannel.join(GameDataFileAccess.load(GameDataFileAccess.DEFAULT_SAVE_PATH))

func _on_quit_button_pressed() -> void:
	GameChannel.quit()

func _on_world_name_submitted(new_text: String) -> void:
	if GameDataFileAccess.save_exists(new_text):
		_start_button.text = "CONTINUE"
	else:
		_start_button.text = "CREATE"
