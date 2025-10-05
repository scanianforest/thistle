class_name AttackComponent extends Node2D


@export var attack_area: Attacker


func _ready() -> void:
	if not attack_area: push_error("AttackComponent needs an attack_area assigned")

func attack() -> void:
	print("attacked")