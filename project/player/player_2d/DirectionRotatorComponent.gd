class_name DirectionRotatorComponent extends Node2D

enum FaceDirection { UP, DOWN, LEFT, RIGHT }


func update_direction(direction: Vector2) -> void:
	var angle = direction.angle()

	# prefer left and right over up DOWN
	if abs(direction.x) >= abs(direction.y):
		if direction.x > 0:
			angle = 0  # RIGHT
		else:
			angle = PI  # LEFT
	else:
		if direction.y > 0:
			angle = PI / 2  # DOWN
		else:
			angle = -PI / 2  # UP

	rotation = angle
