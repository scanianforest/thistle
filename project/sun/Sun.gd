extends DirectionalLight3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		rotation_degrees.y += delta * 50.0
