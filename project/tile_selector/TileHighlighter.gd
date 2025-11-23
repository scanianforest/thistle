class_name TileHighlighter extends Control

@onready
var debug_placeable: PlaceableResource = preload("res://placeables/item_container/chest/chest.tres")
@onready var texture: Texture2D = preload("res://aseprite/white_tile.aseprite")

var ci_rid: RID

const OK: Color = Color(0.2, 0.8, 0.2, 0.5)
const NOT_OK: Color = Color(0.8, 0.2, 0.2, 0.5)
const OK_HIGHLIGHT: Color = Color(0.5, 0.8, 0.5, 0.5)
const NOT_OK_HIGHLIGHT: Color = Color(1, 0.5, 0.5, 0.5)


func _ready() -> void:
	ci_rid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(ci_rid, get_canvas_item())
	RenderingServer.canvas_item_set_z_index(ci_rid, -1)


func highlight_tiles(ok: Array[Vector2i], grid_size: Vector2) -> void:
	RenderingServer.canvas_item_clear(ci_rid)
	for tile in ok:
		var cell_pos = Vector2(tile.x, tile.y)
		# minus half grid to center highlight
		RenderingServer.canvas_item_add_texture_rect(
			ci_rid, Rect2(cell_pos - grid_size / 2, grid_size), texture, false, OK
		)


func show_preview(_placeable: PlaceableResource, pos: Vector2) -> void:
	# render preview of sprite at origin tile
	var placeable = debug_placeable
	var xform = Transform2D.IDENTITY

	RenderingServer.canvas_item_add_texture_rect(
		ci_rid,
		Rect2(placeable.sprite_offset, placeable.sprite.get_size()),
		placeable.sprite,
		false,
		Color(1, 1, 1, 0.9)
	)

	# transform the preview to the origin, snapping to grid
	xform.origin = pos
	RenderingServer.canvas_item_set_transform(ci_rid, xform)
