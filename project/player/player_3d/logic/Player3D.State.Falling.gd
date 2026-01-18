extends ThistleState

var vertical_velocity: float = 0.0
var input: PlayerInput


func _setup() -> void:
	add_to(hsm.idling)
	add_to(hsm.moving)

	input = blackboard.get_var("input")


func _enter() -> void:
	dispatch("animate", "fall")


func _update(_delta: float) -> void:
	vertical_velocity = agent.velocity.y
	vertical_velocity += agent.get_gravity().y * _delta
	dispatch("set_vertical_velocity", vertical_velocity)

	if agent.is_on_floor():
		to(hsm.moving)
