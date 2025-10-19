extends PanelContainer


@onready var _player_inventory_grid: GridContainer = %PlayerInventoryGrid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerChannel.inventory_updated.connect(_on_player_inventory_updated)

	_on_player_inventory_updated([])
	visible = false

func _on_player_inventory_updated(items: Array) -> void:
	for child in _player_inventory_grid.get_children():
		child.name += "_old"
		child.queue_free()
	
	for item in items:
		var sprite = Sprite2D.new()
		sprite.texture = load("res://icon.svg")
		_player_inventory_grid.add_child(sprite)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		visible = not visible