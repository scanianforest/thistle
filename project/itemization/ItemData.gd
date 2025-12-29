class_name ItemData

static var ID_TEMPLATE: String = "%s:%s"  # resource_path + UUID

var resource: ItemResource

var wear: int


func _init(res: ItemResource):
	resource = res
	id = ID_TEMPLATE % [resource.resource_path, UUID.v4()]


var id: String

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


func is_equal(other: ItemData) -> bool:
	return id == other.id


func to_dict() -> Dictionary:
	return {
		"id": id,
		"resource": resource.resource_path,
	}


static func from_dict(dict: Dictionary) -> ItemData:
	var res = ResourceLoader.load(dict.get("resource", null))

	Log.debug("Deserialized item dict: ", dict)

	var item_data = ItemData.new(res)
	item_data.id = dict.get("id", ID_TEMPLATE % [res.resource_path, UUID.v4()])

	return item_data
