extends Node2D

@export var _grid_size: Vector2 = Vector2(16, 16)

@onready var _parent = get_parent()

var active: bool = true:
	set(value):
		visible = value
		process_mode = Node.PROCESS_MODE_INHERIT if value else Node.PROCESS_MODE_DISABLED

func activate(): active = true

func deactivate(): active = false

func _process(_delta: float) -> void:
	# snapped to the grid

func trigger():
	Log.pr("PlacerComponent triggered - override this method in subclasses")
