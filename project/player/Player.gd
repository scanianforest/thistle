class_name Player extends Pawn2D

@export var sprite: PawnSprite
@export var health: HealthComponent
@export var movement: MovementComponent
@export var attacker: AttackComponent
@export var interaction: InteractorComponent
@export var placer: PlacerComponent

var move_direction: Vector2 = Vector2.ZERO

var _data: PlayerData = PlayerData.new():
	set(value):
		if value == null: return
		Log.pr("Setting player data")
		_data = value
		global_position = _data.position

func _ready() -> void:
	GameChannel.starting.connect(_on_game_starting)
	GameChannel.saving.connect(_on_game_saving)

	sprite.animation_event.connect(_on_sprite_animation_event)
	
	health.died.connect(_on_health_died)
	health.health_changed.connect(_on_health_changed)

func _physics_process(_delta: float) -> void:
	movement.move(move_direction)
	sprite.get_node("AnimationPlayer").play("walk" if move_direction != Vector2.ZERO else "idle")
	
	if not move_direction.is_equal_approx(Vector2.ZERO):
		interaction.update_direction(move_direction)
		placer.face(move_direction)
	
	if move_direction.x != 0:
		sprite.flip_h = true if move_direction.x < 0 else false
		

#region Base

func possess() -> void:
	Log.info("Player possessed")
	PlayerChannel.possess(self)

func unpossess() -> void:
	Log.info("Player unpossessed")
	PlayerChannel.unpossess()

func handle_input(event: InputEvent) -> void:
	if event.is_action("left") or event.is_action("right") or event.is_action("up") or event.is_action("down"):
		move_direction = Input.get_vector("left", "right", "up", "down")

#endregion

#region Signal Handlers

func _on_game_starting(game_data: GameData) -> void:
	_data = game_data.player_data

func _on_game_saving(game_data: GameData) -> void:
	_data.position = global_position

	game_data.player_data = _data	# TODO can this be initialized at start instead? Hook up

func _on_sprite_animation_event(event_name: StringName) -> void:
	if event_name == "attack":
		attacker.attack()

func _on_health_died() -> void:
	Log.info("Player has died")

func _on_health_changed(new_health: int) -> void:
	print("Player health changed to %d" % new_health)

#endregion
