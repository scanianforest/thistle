class_name InteractingState extends LimboState

var sprite: PawnSprite


func _setup() -> void:
	sprite = blackboard.get_var("sprite")
	pass


func _enter() -> void:
	var interaction: InteractionComponent = blackboard.get_var("interaction")

	sprite.animate(interaction.animation_name)

	match interaction.interaction_type:
		InteractionComponent.InteractionType.INSTANT:
			_resolve_interaction(interaction)
		InteractionComponent.InteractionType.TIMED:
			_timed_interaction(interaction)
		InteractionComponent.InteractionType.CONTINUOUS:
			_continuous_interaction(interaction)
	pass


func _exit() -> void:
	pass


func _timed_interaction(interaction: InteractionComponent) -> void:
	Log.pr("Starting timed interaction: %s" % interaction)
	var animation_length: float = sprite.get_animation_length(interaction.animation_name)
	await get_tree().create_timer(animation_length).timeout
	_resolve_interaction(interaction)


func _continuous_interaction(interaction: InteractionComponent) -> void:
	Log.pr("Starting continuous interaction: %s" % interaction)


func _resolve_interaction(interaction: InteractionComponent) -> void:
	match interaction:
		_ when interaction is ItemPickupArea:
			dispatch("to_pickup_item")
			Log.pr("Resolving item pickup interaction")
			return
		_ when interaction is OpenContainerInteraction:
			dispatch("to_inventory")
			Log.pr("Resolving open container interaction")
			return
		_:
			Log.pr("Resolving generic interaction %s" % interaction)
			dispatch("to_idle")
