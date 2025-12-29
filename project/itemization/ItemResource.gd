@tool
class_name ItemResource extends Resource

@export var item_name: String = ""
@export_multiline var description: String = ""
@export var components: Array[ItemComponentResource] = []
@export var weight: float = 1.0
@export var stackable: bool = false
@export var max_durability: int = 100

@export_group("Visuals")
@export var inventory_icon: Texture2D
@export var sprite: Texture2D
@export var sprite_offset: Vector2 = Vector2.ZERO

var id: String:
	get:
		var file_name = resource_path.split("/")[-1]
		var item_id = file_name.split(".")[0]
		return item_id
