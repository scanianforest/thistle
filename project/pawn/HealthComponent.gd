class_name HealthComponent extends Node

signal health_changed(new_health: int)
signal max_health_changed(new_max_health: int)
signal died

@export var max_health: int = 100:
	set(value):
		max_health = value
		current_health = min(current_health, max_health)
		max_health_changed.emit(max_health)

@export var current_health: int:
	set(value):
		current_health = clamp(value, 0, max_health)
		health_changed.emit(current_health)
		if current_health <= 0:
			died.emit()

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health -= amount

func heal(amount: int) -> void:
	current_health += amount