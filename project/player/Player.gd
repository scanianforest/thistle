extends CharacterBody2D

@export var _speed: float = 300.0
@export var attacker: Attacker
@export var sprite: PawnSprite

func _ready() -> void:
	sprite.animation_event.connect(_on_sprite_animation_event)

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * _speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, _speed)

	move_and_slide()


#region Animation Event Handlers
func _on_sprite_animation_event(event_name: StringName) -> void:
	if event_name == "attack":
		attacker.attack()
#endregion