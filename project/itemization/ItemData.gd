class_name ItemData

var resource: ItemResource


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
