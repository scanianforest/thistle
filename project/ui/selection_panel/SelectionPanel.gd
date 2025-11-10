@abstract class_name SelectionPanel
extends Node

signal selected(option)

@onready var input = %Input
@onready var options_button: OptionButton = %Options
@onready var create_button: Button = %CreateButton
@onready var delete_button: Button = %DeleteButton

@abstract func _get_options() -> Array[String]

@abstract func _get_option_data(text: String) -> Variant

@abstract func _on_create_option(text: String) -> void

@abstract func _on_delete_option(index: int) -> void


func _ready() -> void:
	options_button.item_selected.connect(_on_option_selected)

	input.text_changed.connect(_on_input_changed)
	input.text_submitted.connect(_on_input_submitted)

	create_button.pressed.connect(_on_create_button_pressed)

	delete_button.pressed.connect(_on_delete_button_pressed)

	_setup.call_deferred()


func _setup() -> void:
	_refresh_options()
	if options_button.get_item_count() > 0:
		selected.emit(0)


func _is_input_valid(text: String) -> bool:
	return text.strip_edges() != "" and not _get_options().has(text)


func _refresh_options() -> void:
	options_button.clear()

	for option in _get_options():
		options_button.add_item(str(option))

	delete_button.disabled = options_button.get_item_count() == 0


func _on_option_selected(index: int) -> void:
	delete_button.disabled = index == -1

	if index == -1:
		selected.emit(null)
	else:
		selected.emit(index)


func _on_input_changed(new_text: String) -> void:
	create_button.disabled = not _is_input_valid(new_text)


func _on_input_submitted(new_text: String) -> void:
	if _is_input_valid(new_text):
		_on_create_option(new_text)
		_refresh_options()
		_select_by_name(new_text)


func _on_create_button_pressed() -> void:
	_on_create_option(input.text)
	_refresh_options()
	_select_by_name(input.text)


func _on_delete_button_pressed() -> void:
	var index: int = options_button.get_selected_id()
	_on_delete_option(index)
	_refresh_options()
	if options_button.get_item_count() > 0:
		options_button.select(0)
		selected.emit(0)
	else:
		selected.emit(null)


func _select_by_name(option_name: String) -> void:
	for i in range(options_button.get_item_count()):
		if options_button.get_item_text(i) == option_name:
			options_button.select(i)
			return
