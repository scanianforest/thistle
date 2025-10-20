@tool
class_name ItemResource extends Resource

@export var item_name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture2D
@export var sprite: Texture2D
@export var components: Array[ItemComponentResource] = []

var id: String:
	get: 
		var file_name = resource_path.split("/")[-1]
		var item_id = file_name.split(".")[0]
		return item_id
