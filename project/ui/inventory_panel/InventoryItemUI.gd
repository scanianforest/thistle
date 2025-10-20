class_name InventoryItemUI extends PanelContainer

signal request_drop(item: ItemResource)

var _texture: TextureRect

var item: ItemResource

func _ready() -> void:
	_texture = %Texture
	if not item: return

	_texture.texture = item.icon

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("secondary_action"):
		request_drop.emit(item)
		queue_free()
		
