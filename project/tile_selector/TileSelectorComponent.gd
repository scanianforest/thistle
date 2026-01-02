class_name TileSelectorComponent extends Node2D

@export var grid_size: Vector2 = Vector2(16, 16)

@onready var highlighter: TileHighlighter = $TileHighlighter

var _last_dir: Vector2 = Vector2(1, 0)

enum Mode {
	OFF,
	DIRECTIONAL,
	FREE,
}

var mode: Mode = Mode.OFF:
	set(value):
		mode = value
		match mode:
			Mode.OFF:
				visible = false
			Mode.DIRECTIONAL, Mode.FREE:
				visible = true


func _ready() -> void:
	UIChannel.input_event.connect(_on_ui_input_event)
	mode = Mode.OFF


func _process(_delta: float) -> void:
	match mode:
		Mode.DIRECTIONAL:
			var pos = get_direction_tile_center()
			highlighter.highlight_tiles([pos], grid_size)
		Mode.FREE:
			var tile = get_mouse_tile_center()
			highlighter.highlight_tiles([tile], grid_size)
		Mode.OFF:
			return


func face(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		_last_dir = direction.normalized()


func get_direction_tile_center() -> Vector2:
	var offset: Vector2 = Vector2(16, 0)
	var rotated_offset: Vector2 = offset.rotated(_last_dir.angle())
	var pos = global_position + rotated_offset
	var snapped_position: Vector2 = pos.snapped(grid_size)
	return snapped_position


func get_mouse_tile_center() -> Vector2:
	var mouse_pos: Vector2 = get_global_mouse_position() - grid_size / 2  # minus half grid to center selection
	var snapped_position: Vector2 = mouse_pos.snapped(grid_size) + grid_size / 2  # plus half grid to place pointer at center
	return snapped_position


func trigger():
	match mode:
		Mode.DIRECTIONAL:
			PlaceableSpawner.spawn(
				highlighter.debug_placeable,
				find_parent("TopDownWorld2D"),
				get_direction_tile_center()
			)
		Mode.FREE:
			PlaceableSpawner.spawn(
				highlighter.debug_placeable, find_parent("TopDownWorld2D"), get_mouse_tile_center()
			)


func _on_ui_input_event(event: InputEvent) -> void:
	if mode == Mode.OFF:
		return
	if event.is_action_pressed("primary_action"):
		trigger()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_placer"):
		match mode:
			Mode.OFF:
				mode = Mode.FREE
			Mode.FREE:
				mode = Mode.DIRECTIONAL
			Mode.DIRECTIONAL:
				mode = Mode.OFF

# func _unhandled_input(event: InputEvent) -> void:
# # TODO replace with non-terrain placer logic
# if event.is_action_pressed("quick_action_1"):
# 	WorldChannel.request_grass(_placer_origin.global_position)
# if event.is_action_pressed("quick_action_0"):
# 	WorldChannel.request_dirt(_placer_origin.global_position)
