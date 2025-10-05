class_name MovementComponent extends Node 

@export var speed: float = 75.0
@export var acceleration: float = 75

var parent_body: CharacterBody2D

func _ready() -> void:
	parent_body = get_parent() as CharacterBody2D
	if not parent_body:
		Log.error("MovementComponent must be a child of CharacterBody2D")

func move(direction: Vector2) -> void:
	if not parent_body:
		return
	if direction:
		parent_body.velocity = direction * speed
	else:
		parent_body.velocity = parent_body.velocity.move_toward(Vector2.ZERO, speed)
	parent_body.move_and_slide()