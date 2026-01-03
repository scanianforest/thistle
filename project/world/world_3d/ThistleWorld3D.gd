extends Node3D

var data: SaveData


func unpause() -> void:
	get_tree().paused = false


func pause() -> void:
	get_tree().paused = true
