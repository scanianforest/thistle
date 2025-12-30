class_name WorldSlot extends Button

@export_group("Nodes")
@export var _name_label: Label
@export var _days_passed_label: Label

var data: WorldData:
	get:
		return data
	set(value):
		data = value
		_update_ui()


func _ready() -> void:
	%DeleteButton.pressed.connect(_on_delete_button_pressed)


func _update_ui() -> void:
	if data != null:
		_name_label.text = data.metadata.name
		_days_passed_label.text = "Day %s" % str(4)
	else:
		_name_label.text = "ERROR NO DATA"
		_days_passed_label.text = ""


func _on_delete_button_pressed() -> void:
	if WorldSaveFileAccess.delete(data.metadata.name):
		queue_free()
