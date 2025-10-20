@tool
extends InteractionComponent

@export var item: ItemResource
@onready var sprite: Sprite2D = $Sprite2D

var tween: Tween

func _ready() -> void:
	sprite.texture = item.sprite

func interact(interactor: InteractorComponent) -> void:
	if tween and tween.is_running():
		return
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "global_position", interactor.get_parent_global_position(), 0.1)
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	tween.set_parallel(false)
	tween.tween_callback(func():
		var inventory: InventoryComponent = interactor.get_sibling_component("InventoryComponent")
		if inventory: inventory.add_item(Item.new(item))
		else: Log.err("Interacting parent has no InventoryComponent, cannot add item")
	)
	tween.tween_callback(queue_free)
