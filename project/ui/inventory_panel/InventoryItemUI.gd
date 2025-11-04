class_name InventoryItemUI extends PanelContainer

signal drop_requested(item: Item)

var _texture: TextureRect

var item: Item


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1


func _ready() -> void:
	_texture = %Texture
	if not item:
		return

	_texture.texture = item.resource.icon


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("secondary_action"):
		drop_requested.emit(item)


func _get_drag_data(at_position: Vector2) -> Variant:
	print("drag start", at_position)

	var preview = Control.new()
	var dup = duplicate()
	preview.add_child(dup)
	dup.position = -0.5 * size

	modulate.a = 0.5

	set_drag_preview(preview)
	return item


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	print("can drop data", at_position)
	return true


func _drop_data(at_position: Vector2, data: Variant) -> void:
	print("dropped", at_position)
