class_name Item

@export var _resource: ItemResource
@export var _durability: float
@export var _max_durability: float

func _init(resource: ItemResource, durability: int, max_durability: int):
	_resource = resource
	_durability = durability
	_max_durability = max_durability
