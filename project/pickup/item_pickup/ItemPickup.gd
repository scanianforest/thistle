@tool
class_name ItemPickup extends Area2D

@export var resource: ItemResource:
	set(v):
		item = ItemData.new(v)
		resource = v
	get:
		return resource

@export var sprite: Sprite2D

var item: ItemData:
	set(v):
		item = v
		if not sprite:
			return
		sprite.texture = item.resource.sprite
	get:
		return item

var item_dict: Dictionary:
	get:
		return item.to_dict()
	set(v):
		item = ItemData.from_dict(v)

var count: int = 1

var _tween: Tween


func _ready() -> void:
	_tween = create_tween()
	_tween.tween_property(sprite, "offset:y", sprite.offset.y - 1, 1.0).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(sprite, "offset:y", sprite.offset.y + 1, 1.0).set_ease(Tween.EASE_IN_OUT)
	_tween.set_loops()

	get_tree().create_timer(0.5).timeout.connect(_activate)


func _activate() -> void:
	monitorable = true


func on_pickup(player: Player) -> void:
	get_parent().pick_up.rpc(player.get_path(), get_path())
