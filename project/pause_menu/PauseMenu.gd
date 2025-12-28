extends Control

@export var _game: Game

@onready var _resume = %ResumeButton
@onready var _settings = %OptionsButton
@onready var _quit_to_main_menu = %QuitToMainMenuButton
@onready var _quit_to_desktop = %QuitToDesktopButton


func _ready() -> void:
	UIChannel.pause_menu_opened.connect(show)

	_resume.pressed.connect(_on_resume_pressed)
	_settings.pressed.connect(_on_settings_pressed)
	_quit_to_main_menu.pressed.connect(_on_quit_to_main_menu_pressed)
	_quit_to_desktop.pressed.connect(_on_quit_to_desktop_pressed)


func _on_resume_pressed() -> void:
	hide()


func _on_settings_pressed() -> void:
	Log.todo("TODO: Open settings menu")


func _on_quit_to_main_menu_pressed() -> void:
	_game.quit(false)
	hide()


func _on_quit_to_desktop_pressed() -> void:
	_game.quit(true)
	hide()
