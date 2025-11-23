@tool
class_name ItemContainer extends StaticBody2D

@export var resource: ItemContainerResource
@export var inventory: InventoryComponent

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite.offset = resource.sprite_offset
	sprite.texture = resource.sprite

	inventory.max_weight = resource.weight_capacity
