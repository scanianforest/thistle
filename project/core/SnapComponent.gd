@tool
class_name SnapComponent extends Node2D

var parent: Node2D
@export var tilemap: TileMapLayer


func _notification(what: int) -> void:
	print(what)
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		snap_to_grid()


func _ready() -> void:
	set_notify_transform(true)
	parent = get_parent() as Node2D


func snap_to_grid() -> void:
	if not parent or not tilemap:
		return

	print("Snapping to grid...")

	var cell_size: Vector2 = tilemap.tile_set.tile_size
	var parent_pos: Vector2 = parent.global_position

	var snapped_x: float = round(parent_pos.x / cell_size.x) * cell_size.x
	var snapped_y: float = round(parent_pos.y / cell_size.y) * cell_size.y

	parent.global_position = Vector2(snapped_x, snapped_y)
