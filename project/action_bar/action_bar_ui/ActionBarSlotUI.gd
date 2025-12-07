class_name ActionBarSlotUI extends PanelContainer

signal clicked
signal secondary
signal dropped_on(item: ItemData)

@onready var _texture: TextureRect = %Texture
@onready var _background: Control = %Background

var item: ItemData = null:
	set(value):
		if item == value:
			return

		item = value
		if value != null:
			_texture.texture = value.resource.inventory_icon
		else:
			_texture.texture = null


func activate() -> void:
	_background.visible = true


func deactivate() -> void:
	_background.visible = false


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is InventoryItemUI


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var item_ui: InventoryItemUI = data
	dropped_on.emit(item_ui.item)


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		clicked.emit()
	elif event.is_action_pressed("secondary_action"):
		secondary.emit()
