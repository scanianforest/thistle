class_name InventoryItemUI extends PanelContainer

signal secondary_requested(item: ItemData)
signal remove_requested(item: ItemData)

@onready var _count_label: Label = %StackCount

@onready var _texture: TextureRect = %Texture

enum DragMode { ONE, SPLIT, FULL }


class DragData:
	var source: InventoryItemUI
	var item: ItemData
	var count: int
	var mode: DragMode


var item: ItemData:
	set(v):
		item = v

		if not _texture:
			return
		_texture.texture = item.resource.inventory_icon
	get:
		return item

var count: int:
	set(v):
		count = v
		if _count_label:
			_count_label.text = str(count)
	get:
		return count

var inventory: InventoryComponent


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1


func _ready() -> void:
	if not item:
		return

	_texture.texture = item.resource.inventory_icon

	_count_label.visible = item.resource.stackable
	_count_label.text = str(count)


func remove() -> void:
	remove_requested.emit(item)


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("secondary_action"):
		secondary_requested.emit(item)


func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview = Control.new()
	preview.z_index = 1000
	preview.z_as_relative = false

	var dup = duplicate()
	preview.add_child(dup)
	dup.position = -0.5 * size

	modulate.a = 0.5

	set_drag_preview(preview)

	var drag_data = DragData.new()
	drag_data.source = self
	drag_data.item = item
	if Input.is_key_pressed(KEY_CTRL):
		drag_data.count = 1
	elif Input.is_key_pressed(KEY_SHIFT):
		drag_data.count = ceil(count / 2.0)
	else:
		drag_data.count = count

	return drag_data
