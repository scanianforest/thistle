class_name CharacterSlot extends PanelContainer

@export var _name: Label

signal selected(slot: CharacterSlot)

var data: PlayerData:
	get:
		return data
	set(value):
		data = value
		_update_ui()


func _ready() -> void:
	deselect()


func _update_ui() -> void:
	if data != null:
		_name.text = data.name
	else:
		_name.text = "ERROR NO DATA"


func select() -> void:
	%SelectedPanel.visible = false
	selected.emit(self)


func deselect() -> void:
	%SelectedPanel.visible = true


func _on_delete_button_pressed() -> void:
	if PlayerSaveFileAccess.delete(data.metadata.name):
		queue_free()
