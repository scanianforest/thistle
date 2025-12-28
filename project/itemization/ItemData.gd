class_name ItemData

var resource: ItemResource

var wear: int


func _init(res: ItemResource):
	resource = res


var durability: int:
	get:
		return resource.max_durability - wear

var weight: float:
	get:
		return resource.weight

var stackable: bool:
	get:
		return resource.stackable

var description: String:
	get:
		return resource.description

var item_name: String:
	get:
		return resource.item_name


func to_dict() -> Dictionary:
	return {
		"resource": resource.resource_path,
	}


static func from_dict(data: Dictionary) -> ItemData:
	var res = ResourceLoader.load(data.get("resource", null))
	Log.debug("Deserialized item data: ", data)
	return ItemData.new(res)
