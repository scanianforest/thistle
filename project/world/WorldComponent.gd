class_name WorldComponent extends Node

signal unloaded
signal loaded

var data: Object


func save() -> void:
	SaveFileAccess.save(data)


func load() -> void:
	loaded.emit()


func unload() -> void:
	unloaded.emit()


func create(world_name: String) -> Object:
	data = WorldData.new()
	data.metadata.name = world_name
	return data
