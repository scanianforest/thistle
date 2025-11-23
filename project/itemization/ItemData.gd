class_name ItemData

var resource: ItemResource

var weight: float:
	get:
		return resource.weight if resource else 0.0


func _init(res: ItemResource):
	resource = res


func to_dict() -> Dictionary:
	return {
		"resource": resource.resource_path,
	}


static func from_dict(data: Dictionary) -> ItemData:
	var res = ResourceLoader.load(data.get("resource", null))
	Log.pr("Deserialized item data: ", data)
	return ItemData.new(res)
