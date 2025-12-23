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
	var stylebox: StyleBoxFlat = self.get_theme_stylebox("panel")
	stylebox.set_border_width_all(4)
	self.add_theme_stylebox_override("panel", stylebox)
	selected.emit(self)


func deselect() -> void:
	var stylebox: StyleBoxFlat = self.get_theme_stylebox("panel")
	stylebox.set_border_width_all(0)
	self.add_theme_stylebox_override("panel", stylebox)


func _on_gui_input(event: InputEvent) -> void:
	Log.pr(event)
	if event is InputEventMouseButton and event.pressed:
		select()
