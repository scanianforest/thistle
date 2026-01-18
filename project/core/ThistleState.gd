@abstract
class_name ThistleState extends LimboState

var hsm: LimboHSM:
	get:
		return agent.hsm as LimboHSM


func add_to(state: ThistleState) -> void:
	hsm.add_transition(self, state, state.name)


func to(state: ThistleState) -> bool:
	return hsm.dispatch(state.name)
