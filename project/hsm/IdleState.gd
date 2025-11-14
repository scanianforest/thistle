class_name IdleState extends LimboState

var sprite: PawnSprite


func _setup() -> void:
	sprite = blackboard.get_var("sprite")

	add_event_handler("input", _on_input)


func _enter() -> void:
	sprite.animate("idle")
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		dispatch("to_moving")


func _on_input(event: InputEvent) -> bool:
	if (
		event.is_action("left")
		or event.is_action("right")
		or event.is_action("up")
		or event.is_action("down")
	):
		dispatch("to_moving")
		return true

	if event.is_action_pressed("toggle_inventory"):
		dispatch("to_inventory")

		return true

	return false
