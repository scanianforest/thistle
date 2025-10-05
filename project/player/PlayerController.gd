class_name PlayerController extends Node

var possessed_pawn: Pawn2D

func set_possessed_pawn(pawn: Pawn2D) -> void:
	Log.log("Player possessed %s" % pawn)
	possessed_pawn = pawn

func _unhandled_input(event: InputEvent) -> void:
	if possessed_pawn: 
		possessed_pawn.handle_input(event)