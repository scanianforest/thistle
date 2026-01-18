extends ThistleState

var input: PlayerInput

var _direction: Vector3 = Vector3.ZERO


func _setup() -> void:
	hsm = agent.hsm as Player3D_HSM

	add_to(hsm.idling)
	add_to(hsm.jumping)
	add_to(hsm.falling)

	input = blackboard.get_var("input")

	add_event_handler(&"input_event", _on_input_event)


func _enter() -> void:
	dispatch("animate", "run")


func _update(delta: float) -> void:
	var speed = 5
	var acc = 12

	var _velocity = agent.velocity

	_direction.x = input.move_direction.x
	_direction.z = input.move_direction.y

	_velocity = _velocity.move_toward(_direction * speed, acc * delta)
	dispatch("set_velocity", _velocity)


func _on_input_event(event: InputEvent) -> bool:
	if event.is_action_pressed("jump"):
		return to(hsm.jumping)

	return false
