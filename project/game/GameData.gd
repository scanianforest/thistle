class_name GameData

var metadata: SaveMetadata = SaveMetadata.new()
var player_data: PlayerData = PlayerData.new()
var world_data: WorldData = WorldData.new()

func to_dict() -> Dictionary:
	return {
		"metadata": metadata.to_dict(),
		"player_data": player_data.to_dict(),
		"world_data": world_data.to_dict()
	}

static func from_dict(dict: Dictionary) -> GameData:
	var data: GameData = GameData.new()

	data.metadata = SaveMetadata.from_dict(dict.get("metadata", SaveMetadata.new().to_dict()))
	data.player_data = PlayerData.from_dict(dict.get("player_data", PlayerData.new().to_dict()))
	data.world_data = WorldData.from_dict(dict.get("world_data", WorldData.new().to_dict()))

	return data
