class_name ItemPickupArea extends InteractionArea2D

var item: ItemData

@export var sprite: Sprite2D


func _ready() -> void:
	sprite.texture = item.resource.sprite
	(interaction as ItemPickupInteraction).item = item
