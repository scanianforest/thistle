class_name Player extends Pawn2D
@export var sprite: PawnSprite
@export var health: HealthComponent
@export var movement: MovementComponent
@export var attacker: AttackComponent
@export var interaction: InteractorComponent
@export var placer: PlacerComponent
@export var inventory: InventoryComponent

var move_direction: Vector2 = Vector2.ZERO

var data: PlayerData = PlayerData.new():
	set(value):
		if value == null:
			return
		Log.pr("Setting player data")
		data = value
		global_position = data.position
		inventory.data = data.inventory_data


func _ready() -> void:
	print("Player ready")

	sprite.animation_event.connect(_on_sprite_animation_event)

	health.died.connect(_on_health_died)
	health.health_changed.connect(_on_health_changed)

	inventory.item_added.connect(_on_inventory_item_added)
	inventory.item_removed.connect(_on_inventory_item_removed)
	inventory.inventory_updated.connect(_on_inventory_updated)
	inventory.item_rejected.connect(_on_inventory_item_rejected)
	inventory.item_dropped.connect(_on_inventory_item_dropped)

	UIChannel.set_inventory.call_deferred(inventory)


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
	if (
		event.is_action("left")
		or event.is_action("right")
		or event.is_action("up")
		or event.is_action("down")
	):
		move_direction = Input.get_vector("left", "right", "up", "down")


#endregion


#region Signal Handlers
func load_from_data(player_data: PlayerData) -> void:
	data = player_data


func save_to_data() -> PlayerData:
	data.position = global_position
	data.inventory_data = inventory.data
	return data


func _on_sprite_animation_event(event_name: StringName) -> void:
	if event_name == "attack":
		attacker.attack()


func _on_health_died() -> void:
	Log.info("Player has died")


func _on_health_changed(new_health: int) -> void:
	print("Player health changed to %d" % new_health)


func _on_inventory_item_added(item: ItemData) -> void:
	PlayerChannel.on_inventory_item_added(item)


func _on_inventory_item_removed(item: ItemData) -> void:
	PlayerChannel.on_inventory_item_removed(item)


func _on_inventory_item_dropped(item: ItemData) -> void:
	ItemSpawner.spawn_item(item, get_parent(), global_position)


func _on_inventory_updated(items: Array[ItemData]) -> void:
	PlayerChannel.on_inventory_updated(items)


func _on_inventory_item_rejected(item: ItemData) -> void:
	PlayerChannel.on_inventory_item_rejected(item)
#endregion
