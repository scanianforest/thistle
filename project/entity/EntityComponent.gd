class_name EntityComponent extends Node

@export var _id: String
@export var _scene: PackedScene


func _enter_tree() -> void:
	name = "Entity_%" % (_id if _id else UUID.v4())
