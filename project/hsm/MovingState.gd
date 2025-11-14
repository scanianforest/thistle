class_name MovingState extends LimboState

var movement: MovementComponent
var sprite: PawnSprite
var interactor: InteractorComponent
var placer: PlacerComponent

var direction: Vector2 = Vector2.ZERO


func _setup() -> void:
	sprite = blackboard.get_var("sprite")
	movement = blackboard.get_var("movement")
	interactor = blackboard.get_var("interactor")
	placer = blackboard.get_var("placer")

	add_event_handler("input", _on_input)


func _enter() -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	sprite.animate("walk")

	_face()


func _update(_delta: float) -> void:
	movement.move(direction)


func _face() -> void:
	if not direction.is_equal_approx(Vector2.ZERO):
		interactor.update_direction(direction)
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

		_face()
		return true

	if event.is_action_pressed("toggle_inventory"):
		dispatch("to_inventory")
		return true

	return false
