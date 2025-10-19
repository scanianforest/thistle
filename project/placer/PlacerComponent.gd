class_name PlacerComponent extends Node2D

@export var _grid_size: Vector2 = Vector2(16, 16)

@onready var _placer_origin: Node2D = %PlacerOrigin

var face_dir := Vector2.RIGHT

var active: bool = true:
	set(value):
		visible = value
		process_mode = Node.PROCESS_MODE_INHERIT if value else Node.PROCESS_MODE_DISABLED

func activate(): active = true

func deactivate(): active = false

func face(direction: Vector2) -> void:
	# update placer origin position based on parent position and facing direction
	var half_grid_offset = direction * _grid_size / 1.5
	var directed_position = get_parent().global_position + half_grid_offset
	
	# Calculate tile coordinates and convert back to world position centered on tile
	var tile_coord = Vector2i(
		floor(directed_position.x / _grid_size.x),
		floor(directed_position.y / _grid_size.y)
	)
	var centered_position = Vector2(tile_coord) * _grid_size + (_grid_size * 0.5)
	_placer_origin.global_position = centered_position


func trigger():
	Log.pr("PlacerComponent triggered - override this method in subclasses")

func _unhandled_input(event: InputEvent) -> void:
	# TODO replace with non-terrain placer logic
	if event.is_action_pressed("quick_action_1"):
		WorldChannel.request_grass(_placer_origin.global_position)
	if event.is_action_pressed("quick_action_0"):
		WorldChannel.request_dirt(_placer_origin.global_position)
