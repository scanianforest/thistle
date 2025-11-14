class_name AttackerComponent extends Node2D

@export var attack_area: Area2D


func _ready() -> void:
	if not attack_area:
		push_error("AttackerComponent needs an attack_area assigned")


func attack() -> void:
	print("attacked")
