class_name InteractingState extends LimboState

var sprite: PawnSprite


func _setup() -> void:
	sprite = blackboard.get_var("sprite")
	pass


func _enter() -> void:
	Log.pr("Entered Interacting State, current interaction: %s" % blackboard.get_var("interaction"))
	var interaction: InteractionComponent = blackboard.get_var("interaction")

	Log.pr("should play interaction animation: %s" % interaction.get_animation_name())

	# todo
	dispatch("to_idle")
	Log.pr("NOTE: Exiting Interacting State immediately for now")
	pass


func _exit() -> void:
	pass
