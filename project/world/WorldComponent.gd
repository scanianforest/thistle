class_name WorldComponent extends Node

signal unloaded
signal loaded

var data: Object


func load() -> void:
	loaded.emit()


func unload() -> void:
	unloaded.emit()
