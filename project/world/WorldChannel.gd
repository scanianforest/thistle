extends Node


signal grass_requested(global_position: Vector2)
signal dirt_requested(global_position: Vector2)

signal ground_tile_changed(x: int, y: int, new_tile: int)

func request_grass(global_position: Vector2) -> void:
	grass_requested.emit(global_position)

func request_dirt(global_position: Vector2) -> void:
	dirt_requested.emit(global_position)

func change_ground_tile(x: int, y: int, new_tile: int) -> void:
	ground_tile_changed.emit(x, y, new_tile)