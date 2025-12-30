extends MarginContainer

signal world_selected(world_data: WorldData)

@onready var _new_world_button: Button = %NewWorldButton

var _button_group: ButtonGroup = ButtonGroup.new()


func _ready() -> void:
	_button_group.pressed.connect(_on_button_group_pressed)
	_new_world_button.pressed.connect(_on_new_world_button_pressed)

	refresh()


func refresh() -> void:
	var grid: GridContainer = %WorldGrid
	for c in grid.get_children():
		c.queue_free()

	for world in WorldSaveFileAccess.get_saves():
		var slot: WorldSlot = (
			preload("res://ui/world_selection_panel/world_slot.tscn").instantiate()
		)

		slot.data = world
		slot.button_group = _button_group
		grid.add_child(slot)


func _on_button_group_pressed(world_slot: WorldSlot) -> void:
	world_selected.emit(world_slot.data)


func _on_new_world_button_pressed() -> void:
	var world_name: String = %NameEdit.text.strip_edges()
	if world_name == "":
		Log.error("World name cannot be empty")
		return

	var new_world_data: WorldData = WorldData.new()
	new_world_data.metadata.name = world_name

	WorldSaveFileAccess.save(world_name, new_world_data)

	refresh.call_deferred()
