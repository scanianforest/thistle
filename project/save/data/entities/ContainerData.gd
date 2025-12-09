class_name ContainerData

var position: Vector2 = Vector2.ZERO
var inventory_data: InventoryData = InventoryData.new()


func to_dict() -> Dictionary:
	return {"position": position, "inventory_data": inventory_data.to_dict()}


static func from_dict(dict: Dictionary) -> ContainerData:
	var container_data := ContainerData.new()

	var inventory_data_dict: Dictionary = dict.get("inventory_data", {})

	container_data.inventory_data = InventoryData.from_dict(inventory_data_dict)

	var pos: Vector2 = dict.get("position", Vector2.ZERO)

	container_data.position = pos

	return container_data
