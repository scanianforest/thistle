class_name DirectionRotatorComponent extends Node2D


func update_direction(direction: Vector2) -> void:
	rotation = lerp_angle(rotation, direction.angle(), get_physics_process_delta_time() * 50.0)
