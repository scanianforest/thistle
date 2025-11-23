class_name ContainerData

var position: Vector2 = Vector2.ZERO
var items: Array[ItemData] = []


func to_dict() -> Dictionary:
	var item_dicts := items.map(func(item): return item.to_dict())
	return {"position": position, "items": item_dicts}


static func from_dict(dict: Dictionary) -> ContainerData:
	var container_data := ContainerData.new()

	for item_dict in dict.get("items", []):
		var item_data := ItemData.from_dict(item_dict)
		container_data.items.append(item_data)

	var pos: Vector2 = dict.get("position", Vector2.ZERO)

	container_data.position = pos

	return container_data
