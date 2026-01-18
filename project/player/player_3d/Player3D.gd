extends CharacterBody3D

@export var hsm: Player3D_HSM

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var data: Player3D_Data:
	get:
		return data
	set(value):
		data = value
		global_position = data.position
		rotation = data.rotation

var input_dir: Vector2


func _ready() -> void:
	if is_multiplayer_authority():
		$PhantomCamera3D.priority = 1

	global_position += Vector3.RIGHT.rotated(Vector3.UP, randf_range(0, TAU)) * 0.2

	hsm.initialize(self)
	hsm.set_active(true)

	hsm.add_event_handler(&"set_velocity", _on_set_velocity)
	hsm.add_event_handler(&"set_vertical_velocity", _on_set_vertical_velocity)
	hsm.add_event_handler(&"animate", _on_animate)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func save() -> SaveData:
	assert(data)
	data.position = global_position
	data.rotation = rotation
	return data


func handle_input(event: InputEvent) -> void:
	hsm.dispatch("input_event", event)
	if (
		event.is_action("left")
		or event.is_action("right")
		or event.is_action("up")
		or event.is_action("down")
	):
		input_dir = Input.get_vector("left", "right", "up", "down")

	else:
		UIChannel.on_input_event(event)


func _on_set_velocity(new_velocity: Vector3) -> bool:
	velocity = new_velocity
	return true


func _on_set_vertical_velocity(new_vertical_velocity: float) -> bool:
	velocity.y = new_vertical_velocity
	return true


func _on_animate(animation_name: String) -> bool:
	$AnimationPlayer.play(animation_name)
	return true
