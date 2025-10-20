class_name ItemDB extends Node

var dictionary: Dictionary[StringName, ItemResource]

static func get_resource(id: String) -> ItemResource:
	var resource = load("res://itemization/items/item_%s.tres" % id)
	return resource
