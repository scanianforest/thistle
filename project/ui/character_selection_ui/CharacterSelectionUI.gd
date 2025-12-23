extends MarginContainer

@onready var grid: GridContainer = %CharacterGrid

var _slot_scene: PackedScene = preload("res://ui/character_selection_ui/character_slot.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh()


func refresh() -> void:
	for c in grid.get_children():
		c.queue_free()

	for player in PlayerSaveFileAccess.get_saves():
		var slot: CharacterSlot = _slot_scene.instantiate()
		slot.data = player
		slot.selected.connect(_on_slot_selected)
		grid.add_child(slot)


func _on_slot_selected(slot: CharacterSlot) -> void:
	for c in grid.get_children():
		if c != slot:
			c.deselect()
