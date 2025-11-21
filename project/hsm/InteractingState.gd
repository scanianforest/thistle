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
			_resolve_interaction(interaction)
		InteractionResource.Type.TIMED:
			_timed_interaction(interaction)
		InteractionResource.Type.ANIMATION:
			_timed_interaction(interaction)  # TODO make animation-specific handling
		InteractionResource.Type.CONTINUOUS:
			_continuous_interaction(interaction)
	pass


func _exit() -> void:
	pass


func _timed_interaction(interaction: Interaction) -> void:
	Log.pr("Starting timed interaction: %s" % interaction)
	var animation_length: float = sprite.get_animation_length(
		interaction.interaction_resource.animation_name
	)
	await get_tree().create_timer(animation_length).timeout
	_resolve_interaction(interaction)


func _continuous_interaction(interaction: Interaction) -> void:
	Log.pr("Starting continuous interaction: %s" % interaction)
	await interactor.stopped
	dispatch("to_idle")


func _resolve_interaction(interaction: Interaction) -> void:
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
