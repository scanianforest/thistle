extends Node


signal ground_tile_changed(x: int, y: int, new_tile: int)


func change_ground_tile(x: int, y: int, new_tile: int) -> void:
	ground_tile_changed.emit(x, y, new_tile)