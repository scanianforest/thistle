class_name MovingState extends LimboState

var movement: MovementComponent
var sprite: PawnSprite
var interactor: InteractorComponent
var placer: PlacerComponent
var direction_rotator: DirectionRotatorComponent

var direction: Vector2 = Vector2.ZERO


func _setup() -> void:
	sprite = blackboard.get_var("sprite")
	interactor = blackboard.get_var("interactor")
	movement = blackboard.get_var("movement")
	placer = blackboard.get_var("placer")
	direction_rotator = blackboard.get_var("direction_rotator")

	add_event_handler("input", _on_input)


func _enter() -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	sprite.animate("walk")


func _update(_delta: float) -> void:
	movement.move(direction)
	direction_rotator.update_direction(direction)
	placer.face(direction)
	if direction.x != 0:
		sprite.flip_h = true if direction.x < 0 else false


func _on_input(event: InputEvent) -> bool:
	if (
		event.is_action("left")
		or event.is_action("right")
		or event.is_action("up")
		or event.is_action("down")
	):
		direction = Input.get_vector("left", "right", "up", "down")
		if direction.is_zero_approx():
			dispatch("to_idle")

		return true

	if event.is_action_pressed("toggle_inventory"):
		dispatch("to_inventory")
		return true

	if event.is_action_pressed("interact"):
		var interaction: Interaction = interactor.interact()
		if interaction != null:
			blackboard.set_var("interaction", interaction)
			dispatch("to_interacting")
			return true

	return false
