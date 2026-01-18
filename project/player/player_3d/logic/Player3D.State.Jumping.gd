extends ThistleState

var vertical_velocity: float = 0.0


func _setup() -> void:
	add_to(hsm.falling)


func _enter() -> void:
	dispatch("animate", "jump")
	dispatch("set_vertical_velocity", 4)


func _update(delta: float) -> void:
	vertical_velocity = agent.velocity.y
	vertical_velocity += agent.get_gravity().y * delta
	dispatch("set_vertical_velocity", vertical_velocity)

	if vertical_velocity <= 0:
		to(hsm.falling)
