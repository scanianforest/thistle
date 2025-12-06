class_name InteractingState extends LimboState

var sprite: PawnSprite
var interactor: InteractorComponent


func _setup() -> void:
	sprite = blackboard.get_var("sprite")
	interactor = blackboard.get_var("interactor")

	add_event_handler("input", _on_input)
	pass


func _enter() -> void:
	Log.pr("Entering InteractingState")
	var interaction: Interaction = blackboard.get_var("interaction")

	interaction.start(interactor)

	sprite.animate(interaction.interaction_resource.animation_name)

	match interaction.interaction_resource.type:
		InteractionResource.Type.INSTANT:
			_instant_interaction(interaction)
		InteractionResource.Type.TIMED:
			_timed_interaction(interaction)
		InteractionResource.Type.CONTINUOUS:
			_continuous_interaction(interaction)
	pass


func _exit() -> void:
	pass


func _timed_interaction(interaction: Interaction) -> void:
	Log.pr("Starting timed interaction: %s" % interaction)

	await interaction.resolved

	dispatch("to_idle")


func _continuous_interaction(interaction: Interaction) -> void:
	Log.pr("Starting continuous interaction: %s" % interaction)
	await interactor.stopped
	dispatch("to_idle")


func _instant_interaction(interaction: Interaction) -> void:
	Log.pr("Resolving interaction: %s" % interaction)
	interactor.resolve()
	dispatch("to_idle")


func _on_input(event: InputEvent) -> bool:
	var interaction: Interaction = blackboard.get_var("interaction")

	if (
		event.is_action_pressed("left")
		or event.is_action_pressed("right")
		or event.is_action_pressed("up")
		or event.is_action_pressed("down")
	):
		interactor.stop_interaction()
		return true

	for action in interaction.interaction_resource.cancel_actions:
		if event.is_action_pressed(action):
			interactor.stop_interaction()
			return true

	return false
