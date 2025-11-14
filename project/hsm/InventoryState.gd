class_name InventoryState extends LimboState

var sprite: PawnSprite
var inventory: InventoryComponent


func _setup() -> void:
	sprite = blackboard.get_var("sprite")
	inventory = blackboard.get_var("inventory")

	add_event_handler("input", _on_input)


func _enter() -> void:
	sprite.animate("inventory")
	inventory.open()


func _exit() -> void:
	inventory.close()
	pass


func _on_input(event: InputEvent) -> bool:
	if event.is_echo():
		return false

	if event.is_action_pressed("toggle_inventory"):
		dispatch("to_idle")
		return true

	if event.is_pressed() and Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		dispatch("to_moving")
		return true

	return false
