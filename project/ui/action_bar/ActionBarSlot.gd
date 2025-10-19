class_name ActionBarSlot extends PanelContainer

@onready var _texture: TextureRect = %Texture
@onready var _background: ColorRect = %Background

var item: ItemResource = null:
	set(value):
		if item == value: return

		if value != null:
			_texture.texture = value.texture
		else:
			_texture.texture = null

func activate() -> void:
	Log.pr("ActionBarSlot activated - override this method in subclasses")
	_background.visible = true
	

func deactivate() -> void:
	Log.pr("ActionBarSlot deactivated - override this method in subclasses")
	_background.visible = false