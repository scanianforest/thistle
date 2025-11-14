class_name InteractingState extends LimboState


func _setup() -> void:
	pass


func _enter() -> void:
	Log.pr("Entered Interacting State, current interaction: %s" % blackboard.get_var("interaction"))
	pass


func _exit() -> void:
	pass
