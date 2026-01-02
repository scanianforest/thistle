class_name CharacterSlot extends Button

@export var _name: Label

var data: SaveData:
	get:
		return data
	set(value):
		data = value
		_update_ui()


func _update_ui() -> void:
	if data != null:
		_name.text = data.get_name()
	else:
		_name.text = "ERROR NO DATA"


func _on_delete_button_pressed() -> void:
	if SaveFileAccess.delete(data):
		queue_free()
