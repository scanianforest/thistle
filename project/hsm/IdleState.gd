class_name IdleState extends LimboState

var sprite: PawnSprite
var interactor: InteractorComponent
var input: PlayerInput


func _setup() -> void:
	sprite = blackboard.get_var("sprite")
	interactor = blackboard.get_var("interactor")
	input = blackboard.get_var("input")

	add_event_handler("input", _on_input)


func _enter() -> void:
	sprite.animate("idle")

	if is_multiplayer_authority() and input.move_direction != Vector2.ZERO:
		dispatch("to_moving")


func _on_interacted(interaction: Interaction) -> void:
	blackboard.set_var("interaction", interaction)
	dispatch("to_interacting")


func _on_input(event: InputEvent) -> bool:
	if (
		event.is_action("left")
		or event.is_action("right")
		or event.is_action("up")
		or event.is_action("down")
	):
		dispatch("to_moving")
		return true

	if event.is_action_pressed("ui_accept"):
		dispatch("to_attacking")
		return true

	if event.is_action_pressed("toggle_inventory"):
		dispatch("to_inventory")
		return true

	if event.is_action_pressed("interact"):
		var interaction: Interaction = interactor.interact()
		if interaction != null:
			_on_interacted(interaction)
			return true

	return false
