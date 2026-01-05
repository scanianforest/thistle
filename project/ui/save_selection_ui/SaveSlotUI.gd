class_name SaveSlotUI extends Button

@export var _name_label: Label
@export var _description_label: Label

var data: SaveData:
	get:
		return data
	set(value):
		data = value
		_name_label.text = data.get_name()
		_description_label.text = "\n".join(data.get_display_lines())


func _ready() -> void:
	%DeleteButton.pressed.connect(_on_delete_button_pressed)


func _on_delete_button_pressed() -> void:
	if SaveFileAccess.delete(data):
		queue_free()
