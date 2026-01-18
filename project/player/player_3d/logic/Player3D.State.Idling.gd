extends ThistleState

var input: PlayerInput


func _setup() -> void:
	hsm = agent.hsm as Player3D_HSM

	add_to(hsm.moving)
	add_to(hsm.jumping)
	add_to(hsm.falling)

	input = blackboard.get_var("input")

	add_event_handler(&"input_event", _on_input_event)


func _enter() -> void:
	dispatch("animate", "idle")


func _update(_delta: float) -> void:
	if not input.move_direction.is_zero_approx():
		return to(hsm.moving)


func _on_input_event(event: InputEvent) -> bool:
	if event.is_action_pressed("jump"):
		return to(hsm.jumping)

	return false
