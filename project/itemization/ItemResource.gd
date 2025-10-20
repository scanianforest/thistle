@tool
class_name ItemResource extends Resource

@export var item_name: String = ""
@export var icon: Texture2D
@export var sprite: Texture2D

var id: String:
	get: 
		var file_name = resource_path.split("/")[-1]
		var item_id = file_name.split(".")[0]
		return item_id
