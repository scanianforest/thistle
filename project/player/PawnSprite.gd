class_name PawnSprite
extends Sprite2D
## A sprite that can be animated and emit animation events.
##
## PawnSprite is used by player, enemy and other NPC characters.
## It provides functions to animate the sprite and emit signals

signal animation_event(event_name: StringName)
signal animation_finished(animation_name: StringName)

@onready var _anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_anim.animation_finished.connect(_on_animation_finished)


func animate(animation: StringName) -> void:
	_anim.play(animation)


func broadcast_animation_event(event_name: StringName) -> void:
	animation_event.emit(event_name)


func _on_animation_finished(anim_name: StringName) -> void:
	animation_finished.emit(anim_name)
