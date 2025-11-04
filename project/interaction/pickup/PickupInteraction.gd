@tool
extends InteractionComponent

var _item: ItemResource

@export var item: ItemResource:
	set(v):
		_item = v
		item_updated.emit(v)
	get:
		return _item

@onready var sprite: Sprite2D = $Sprite2D

signal item_updated

var tween: Tween
var bob: Tween


func _init() -> void:
	item_updated.connect(_on_item_updated)


func _ready() -> void:
	item = item


func interact(interactor: InteractorComponent) -> void:
	if tween and tween.is_running():
		return
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "global_position", interactor.get_parent_global_position(), 0.1)
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	tween.set_parallel(false)
	tween.tween_callback(
		func():
			var inventory: InventoryComponent = interactor.get_sibling_component(
				"InventoryComponent"
			)
			if inventory:
				inventory.add_item(Item.new(item))
			else:
				Log.err("Interacting parent has no InventoryComponent, cannot add item")
	)
	tween.tween_callback(queue_free)


func _on_item_updated(updated_item: ItemResource) -> void:
	if not is_inside_tree():
		return

	sprite.texture = updated_item.sprite
