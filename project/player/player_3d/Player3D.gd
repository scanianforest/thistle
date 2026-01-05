extends CharacterBody3D

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


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		var rot_y = atan2(direction.x, direction.z)
		$Model.rotation.y = lerp_angle($Model.rotation.y, rot_y, 0.4)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func save() -> SaveData:
	assert(data)
	data.position = global_position
	data.rotation = rotation
	return data


func handle_input(event: InputEvent) -> void:
	if (
		event.is_action("left")
		or event.is_action("right")
		or event.is_action("up")
		or event.is_action("down")
	):
		input_dir = Input.get_vector("left", "right", "up", "down")

	else:
		UIChannel.on_input_event(event)
