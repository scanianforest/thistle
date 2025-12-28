class_name WorldSelectionPanel extends PanelContainer

signal world_selected(data: WorldData)

@onready var world_option_button: OptionButton = %WorldOptionButton
@onready var new_world_name_input: LineEdit = %NewWorldNameInput
@onready var new_world_button: Button = %NewWorldButton
@onready var delete_world_button: Button = %DeleteWorldButton


func _ready() -> void:
	world_option_button.item_selected.connect(_on_world_selected)

	new_world_name_input.text_changed.connect(_on_new_world_name_input_changed)
	new_world_name_input.text_submitted.connect(_on_new_world_name_input_submitted)

	new_world_button.pressed.connect(_on_new_world_button_pressed)

	delete_world_button.pressed.connect(_on_delete_world_button_pressed)

	_ready_deferred.call_deferred()


func _ready_deferred() -> void:
	_refresh_world_list()
	if world_option_button.get_item_count() > 0:
		var world_data = WorldSaveFileAccess.load(world_option_button.get_item_text(0))
		world_selected.emit(world_data)


func _is_new_world_name_valid(world_name: String) -> bool:
	if world_name.strip_edges() == "":
		return false
	if WorldSaveFileAccess.exists(world_name):
		return false
	return true


func _refresh_world_list() -> void:
	world_option_button.clear()
	var saves: Array[WorldData] = WorldSaveFileAccess.get_saves().filter(
		func(save: WorldData) -> bool: return save != null
	)

	for save in saves:
		world_option_button.add_item(save.metadata.name)
	delete_world_button.disabled = world_option_button.get_item_count() == 0


func _select_by_name(world_name: String) -> void:
	for i in range(world_option_button.get_item_count()):
		if world_option_button.get_item_text(i) == world_name:
			world_option_button.select(i)
			return


func _on_new_world_name_input_changed(new_text: String) -> void:
	new_world_button.disabled = not _is_new_world_name_valid(new_text)


func _on_world_selected(index: int) -> void:
	delete_world_button.disabled = index == -1

	var selected_name: String = world_option_button.get_item_text(index)
	var world_data: WorldData = WorldSaveFileAccess.load(selected_name)

	world_selected.emit(world_data)

	Log.info("Selected world:", world_data.metadata.name)


func _on_new_world_name_input_submitted(_new_text: String) -> void:
	_on_new_world_button_pressed()


func _on_new_world_button_pressed() -> void:
	var world_name: String = new_world_name_input.text.strip_edges()

	var world_data: WorldData = WorldData.new()
	world_data.metadata.name = world_name

	WorldSaveFileAccess.save(world_name, world_data)

	new_world_name_input.text = ""
	_refresh_world_list()
	Log.info("Created new world:", world_name)

	_select_by_name(world_name)


func _on_delete_world_button_pressed() -> void:
	var index: int = world_option_button.selected

	var world_name: String = world_option_button.get_item_text(index)
	WorldSaveFileAccess.delete(world_name)

	_refresh_world_list()

	Log.info("Deleted world:", world_name)

	var new_index: int = world_option_button.selected

	if new_index != -1:
		_on_world_selected(new_index)
