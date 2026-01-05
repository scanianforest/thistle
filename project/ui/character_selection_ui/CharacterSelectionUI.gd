extends MarginContainer

signal character_selected(character_data: CharacterData)

@onready var grid: GridContainer = %CharacterGrid

var _button_group: ButtonGroup
var _slot_scene: PackedScene = preload("res://ui/character_selection_ui/character_slot.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_button_group = ButtonGroup.new()
	_button_group.pressed.connect(_on_button_group_pressed)
	%NewCharacterButton.pressed.connect(_on_new_character_button_pressed)

	refresh()


func refresh() -> void:
	for c in grid.get_children():
		c.queue_free()

	for player in SaveFileAccess.get_saves(CharacterData.SAVE_DIR, CharacterData.from_dict):
		var slot: CharacterSlot = _slot_scene.instantiate()
		slot.data = player
		slot.button_group = _button_group
		grid.add_child(slot)


func _on_button_group_pressed(character_slot: CharacterSlot) -> void:
	character_selected.emit(character_slot.data)


func _on_new_character_button_pressed() -> void:
	var new_character_data: CharacterData = CharacterData.new()

	var character_name: String = %NameEdit.text.strip_edges()

	if character_name == "":
		Log.error("Character name cannot be empty")
		return

	new_character_data.metadata.name = character_name

	SaveFileAccess.save(new_character_data)
	refresh.call_deferred()
