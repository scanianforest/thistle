class_name Player_State_Attacking extends LimboState

@onready var attacker: AttackerComponent


func _setup() -> void:
	attacker = agent.attacker
	if not attacker:
		Log.err("Player_State_Attacking requires an AttackerComponent on the agent")


func _enter() -> void:
	dispatch("animate", "attack_club_0")
	attacker.attack()
	await agent.sprite.animation_finished
	dispatch("to_idle")
