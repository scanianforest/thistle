class_name Player extends Pawn2D

signal dropped_item(item: ItemData, count: int)

@export var sprite: PawnSprite
@export var health: HealthComponent
@export var movement: MovementComponent
@export var attacker: AttackerComponent
@export var interactor: InteractorComponent
@export var placer: TileSelectorComponent
@export var inventory: InventoryComponent
@export var actionbar: ActionBarComponent
@export var equipment: EquipmentComponent

@onready var hsm: LimboHSM = $HSM
@onready var idle_state: IdleState = $HSM/Idle
@onready var moving_state: MovingState = $HSM/Moving
@onready var inventory_state: InventoryState = $HSM/Inventory
@onready var interacting_state: InteractingState = $HSM/Interacting

var data: PlayerData = PlayerData.new():
	set(value):
		if value == null:
			return
		Log.pr("Setting player data")
		data = value
		global_position = data.position
		inventory.data = data.inventory_data
		actionbar.load(data.actionbar_data)


func _ready() -> void:
	UIChannel.set_inventory.call_deferred(inventory)
	UIChannel.set_player.call_deferred(self)

	health.died.connect(_on_health_died)
	health.health_changed.connect(_on_health_changed)

	inventory.item_removed.connect(_on_inventory_item_removed)
	inventory.item_dropped.connect(_on_inventory_item_dropped)
	inventory.new_stack_created.connect(_on_inventory_new_stack_created)

	actionbar.slot_selected.connect(_on_actionbar_slot_selected)

	hsm.initial_state = idle_state

	hsm.add_transition(idle_state, moving_state, &"to_moving")
	hsm.add_transition(idle_state, inventory_state, &"to_inventory")
	hsm.add_transition(idle_state, interacting_state, &"to_interacting")

	hsm.add_transition(moving_state, idle_state, &"to_idle")
	hsm.add_transition(moving_state, inventory_state, &"to_inventory")
	hsm.add_transition(moving_state, interacting_state, &"to_interacting")

	hsm.add_transition(inventory_state, idle_state, &"to_idle")
	hsm.add_transition(inventory_state, moving_state, &"to_moving")

	hsm.add_transition(interacting_state, idle_state, &"to_idle")

	hsm.initialize(self)
	hsm.set_active(true)

	$MainCamera.enabled = is_multiplayer_authority()


#region Base
func possess() -> void:
	Log.info("Player possessed")
	PlayerChannel.possess(self)


func unpossess() -> void:
	Log.info("Player unpossessed")
	PlayerChannel.unpossess()


func handle_input(event: InputEvent) -> void:
	if hsm.dispatch("input", event):
		get_viewport().set_input_as_handled()


#endregion


#region Signal Handlers
func load_from_data(player_data: PlayerData) -> void:
	data = player_data


func save_to_data() -> PlayerData:
	data.position = global_position
	data.inventory_data = inventory.data
	data.actionbar_data = actionbar.save()
	return data


func _on_health_died() -> void:
	Log.info("Player has died")


func _on_health_changed(new_health: int) -> void:
	print("Player health changed to %d" % new_health)


func _on_inventory_item_removed(item: ItemData) -> void:
	var index = actionbar.find_item(item)
	if index != -1:
		actionbar.set_slot(index, null)


func _on_inventory_item_dropped(item: ItemData, count: int = 1) -> void:
	dropped_item.emit(item, count)


func _on_inventory_new_stack_created(item: ItemData) -> void:
	var empty_slot = actionbar._get_first_empty_slot()
	if empty_slot != -1:
		actionbar.set_slot(empty_slot, item)


func _on_actionbar_slot_selected(index: int) -> void:
	var item = actionbar.slots[index]
	equipment.equip_item(item)

#endregion
