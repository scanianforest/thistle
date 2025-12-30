class_name CharacterSlot extends Button

@export var _name: Label

var data: PlayerData:
	get:
		return data
	set(value):
		data = value
		_update_ui()


func _update_ui() -> void:
	if data != null:
		_name.text = data.name
	else:
		_name.text = "ERROR NO DATA"


func _on_delete_button_pressed() -> void:
	if PlayerSaveFileAccess.delete(data.metadata.name):
		queue_free()
