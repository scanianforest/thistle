class_name ItemEntity extends Node2D

@export var item_resource: ItemResource:
	set(v):
		item = ItemData.new(v)
		item_resource = v
	get:
		return item_resource

var item: ItemData

@export var sprite: Sprite2D
@export var interaction_area: InteractionArea2D


func _ready() -> void:
	sprite.texture = item.resource.sprite
	sprite.offset = item.resource.sprite_offset
	(interaction_area.interaction as ItemPickupInteraction).item = item


func _on_item_pickup_interaction_resolved() -> void:
	queue_free()
