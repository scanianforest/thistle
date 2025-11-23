class_name ItemContainer extends StaticBody2D

@export var resource: ItemContainerResource
@export var inventory: InventoryComponent

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	inventory.max_weight = resource.weight_capacity
	sprite.offset = resource.sprite_offset
