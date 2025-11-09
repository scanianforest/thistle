class_name InventoryItemUI extends PanelContainer

signal secondary_requested(item: ItemData)
signal remove_requested(item: ItemData)

var _texture: TextureRect

var item: ItemData


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1


func _ready() -> void:
	_texture = %Texture
	if not item:
		return

	_texture.texture = item.resource.icon


func remove() -> void:
	remove_requested.emit(item)


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("secondary_action"):
		secondary_requested.emit(item)


func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview = Control.new()
	var dup = duplicate()
	preview.add_child(dup)
	dup.position = -0.5 * size

	modulate.a = 0.5

	set_drag_preview(preview)
	return self
