class_name ItemPickup extends Node2D

var item: ItemData

@export var sprite: Sprite2D
@export var interaction_area: InteractionArea2D


func _ready() -> void:
	sprite.texture = item.resource.sprite
	(interaction_area.interaction as ItemPickupInteraction).item = item


func _on_item_pickup_interaction_resolved() -> void:
	queue_free()
