class_name AttackerComponent extends Node2D

@export var area: Area2D
@export var sprite: Sprite2D
@export var anim: AnimationPlayer


func _ready() -> void:
	if not area:
		push_error("AttackerComponent needs an area assigned")

	anim.animation_finished.connect(_on_animation_finished)


func attack() -> void:
	if global_rotation_degrees > 90.0 or global_rotation_degrees < -90.0:
		sprite.flip_v = true
	else:
		sprite.flip_v = false

	anim.play("attack_club_0")
	for body in area.get_overlapping_bodies():
		if body.has_method("damage"):
			body.damage(10)


func _on_animation_finished(anim_name: StringName) -> void:
	anim.stop()
