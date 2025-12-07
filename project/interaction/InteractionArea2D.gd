class_name InteractionArea2D extends Area2D

signal selected
signal deselected

@export var interaction: Interaction


func on_selected() -> void:
	selected.emit()


func on_deselected() -> void:
	deselected.emit()
