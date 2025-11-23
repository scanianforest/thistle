class_name EntitiesData

static var key: String = "entities"

var containers: Array[ContainerData] = []


func to_dict() -> Dictionary:
	var container_dicts := containers.map(func(container): return container.to_dict())
	return {"containers": container_dicts}


static func from_dict(dict: Dictionary) -> EntitiesData:
	var data := EntitiesData.new()
	for container_dict in dict.get("containers", []):
		Log.pr("Deserializing container: ", container_dict)
		var container_data := ContainerData.from_dict(container_dict)
		data.containers.append(container_data)
	return data
