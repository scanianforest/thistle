@tool
extends MarginContainer

signal save_selected(save_data: SaveData)

const _slot_ui_scene: PackedScene = preload("res://ui/save_selection_ui/save_slot_ui.tscn")

@export var _title: String = "Select a Save":
	set(value):
		_title = value
		%Title.text = _title
@export var _save_data: Script:
	set(value):
		if not value:
			_save_data = null
			return

		_setup(value)
		_save_data = value

@onready var _grid: GridContainer = %Grid

var _save_dir: String
var _from_dict_func: Callable
var _new_func: Callable

var _button_group: ButtonGroup = ButtonGroup.new()


func _setup(save_data_script: Script) -> void:
	_save_dir = save_data_script.get_script_constant_map().SAVE_DIR
	_from_dict_func = save_data_script.from_dict
	_new_func = save_data_script.new


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup(_save_data)

	_button_group.pressed.connect(_on_button_group_pressed)

	%NewButton.pressed.connect(_on_new_button_pressed)

	_refresh()


func _refresh() -> void:
	if Engine.is_editor_hint():
		return

	for c in _grid.get_children():
		c.queue_free()

	for save in SaveFileAccess.get_saves(_save_dir, _from_dict_func):
		var slot: SaveSlotUI = _slot_ui_scene.instantiate()

		slot.data = save
		slot.button_group = _button_group

		_grid.add_child(slot)


func _on_button_group_pressed(save_slot: SaveSlotUI) -> void:
	save_selected.emit(save_slot.data)
	Log.info("Selected save: %s" % save_slot.data.get_name())
	Log.debug(save_slot.data.to_dict())


func _on_new_button_pressed() -> void:
	var save_name: String = %NameEdit.text.strip_edges()
	if save_name == "":
		Log.error("TopDownWorld2D name cannot be empty")
		return

	var data: SaveData = _new_func.call()
	data.metadata.name = save_name

	SaveFileAccess.save(data)

	_refresh.call_deferred()
