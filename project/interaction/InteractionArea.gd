class_name InteractionArea extends Area2D

@export var interaction: InteractionComponent


func interact(interactor: Node) -> void:
	if interaction:
		interaction.interact(interactor)
	else:
		Log.err("No interaction component assigned to InteractionArea")
