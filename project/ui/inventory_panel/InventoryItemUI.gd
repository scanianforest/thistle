class_name InventoryItemUI extends PanelContainer

signal secondary_requested(item: ItemData)
signal remove_requested(item: ItemData)

@onready var _tooltip: Control = %ItemTooltip
@onready var stack_count: Label = %StackCount

var _texture: TextureRect

var item: ItemData
var count: int


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1


func _ready() -> void:
	_texture = %Texture
	if not item:
		return

	_texture.texture = item.resource.inventory_icon

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	_tooltip.hide()
	_tooltip.item = item

	stack_count.visible = item.resource.stackable
	stack_count.text = str(count)


func remove() -> void:
	remove_requested.emit(item)


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("secondary_action"):
		secondary_requested.emit(item)


func _get_drag_data(_at_position: Vector2) -> Variant:
	_tooltip.hide()

	var preview = Control.new()
	preview.z_index = 1000
	preview.z_as_relative = false
	var dup = duplicate()
	preview.add_child(dup)
	dup.position = -0.5 * size

	modulate.a = 0.5

	set_drag_preview(preview)
	return self


func _on_mouse_entered() -> void:
	_tooltip.show()


func _on_mouse_exited() -> void:
	_tooltip.hide()
