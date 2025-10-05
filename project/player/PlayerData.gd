class_name PlayerData extends SaveData

var position: Vector2 = Vector2.ZERO

func to_dict() -> Dictionary:
    return {
        "position": position
    }

static func from_dict(dict: Dictionary) -> PlayerData:
    var data = PlayerData.new()
    
    data.position = dict.get("position", Vector2.ZERO)
    
    Log.pr("Deserialized player data: ", data.to_dict())
    return data

