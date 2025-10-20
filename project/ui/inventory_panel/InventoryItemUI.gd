class_name InventoryItemUI extends PanelContainer

signal request_drop(item: Item)

var _texture: TextureRect

var item: Item

func _ready() -> void:
	_texture = %Texture
	if not item: return

	_texture.texture = item.resource.icon

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("secondary_action"):
		request_drop.emit(item)
		queue_free()
		
