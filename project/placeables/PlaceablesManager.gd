class_name PlaceablesManager extends Node2D

@onready
var debug_placeable: PlaceableResource = preload("res://placeables/item_container/box/box.tres")

@export var grid_size: Vector2 = Vector2(16, 16)

var ci_rid: RID

@onready var texture: Texture2D = preload("res://aseprite/white_tile.aseprite")


func _ready() -> void:
	ci_rid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(ci_rid, get_canvas_item())
	RenderingServer.canvas_item_set_z_index(ci_rid, -1)


func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = Vector2(get_global_mouse_position()) / grid_size
	RenderingServer.canvas_item_clear(ci_rid)
	show_preview(debug_placeable, mouse_pos - Vector2(0.5, 0.5))


func show_preview(placeable: PlaceableResource, pos: Vector2) -> void:
	var origin = placeable.origin

	# make a grid of the placeable, highlighting the origin
	for x in range(placeable.size.x):
		for y in range(placeable.size.y):
			var cell_pos = Vector2(x - origin.x, y - origin.y)
			var color: Color = (
				Color(0.5, 1, 0.5, 0.75)
				if (x == origin.x and y == origin.y)
				else Color(0.5, 1, 0.5, 0.3)
			)
			RenderingServer.canvas_item_add_texture_rect(
				ci_rid, Rect2(cell_pos * grid_size, grid_size), texture, false, color
			)

	# render preview of sprite at origin tile
	var xform = Transform2D.IDENTITY

	RenderingServer.canvas_item_add_texture_rect(
		ci_rid,
		Rect2(placeable.sprite_offset, placeable.sprite.get_size()),
		placeable.sprite,
		false,
		Color(1, 1, 1, 0.9)
	)

	# transform the preview to the origin, snapping to grid
	xform.origin = (pos.snapped(Vector2(1, 1))) * grid_size
	RenderingServer.canvas_item_set_transform(ci_rid, xform)
