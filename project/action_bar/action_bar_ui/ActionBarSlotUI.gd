class_name ActionBarSlotUI extends PanelContainer

signal clicked

@onready var _texture: TextureRect = %Texture
@onready var _background: ColorRect = %Background

var item: Item = null:
	set(value):
		if item == value: return
		
		item = value
		if value != null:
			_texture.texture = value.resource.icon
		else:
			_texture.texture = null

func activate() -> void:
	Log.pr("ActionBarSlotUI activated - override this method in subclasses")
	_background.visible = true

func deactivate() -> void:
	Log.pr("ActionBarSlotUI deactivated - override this method in subclasses")
	_background.visible = false

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		print("ActionBarSlotUI clicked")
		clicked.emit()