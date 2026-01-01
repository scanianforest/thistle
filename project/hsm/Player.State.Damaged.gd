class_name Player_State_Damaged extends LimboState

var movement: MovementComponent
var health: HealthComponent
var sprite: PawnSprite


func _setup() -> void:
	movement = agent.movement
	health = agent.health
	sprite = agent.sprite


func _enter() -> void:
	var damage = blackboard.get_var("damage_amount", 0)
	if damage == 0:
		Log.warn("Entered Damaged state with 0 damage amount")
		dispatch(&"to_idle")
		return

	health.take_damage(damage)
	sprite.on_damaged()
	dispatch(&"to_idle")
