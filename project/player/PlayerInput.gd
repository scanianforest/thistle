class_name PlayerInput extends Node

var move_direction: Vector2


func _ready() -> void:
	if not is_multiplayer_authority():
		queue_free()
		return


func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action("left")
		or event.is_action("right")
		or event.is_action("up")
		or event.is_action("down")
	):
		move_direction = Input.get_vector("left", "right", "up", "down")

	get_parent().handle_input(event)
