@tool
extends Node2D

@export var _vacuum_radius: float:
	set(value):
		_vacuum_radius = value
		if not _vacuum_shape:
			return
		_vacuum_shape.shape.radius = value
	get():
		return _vacuum_radius

@export_group("Nodes")
@onready var _vacuum_area: Area2D = $VacuumArea
@onready var _pickup_area: Area2D = $PickupArea
@export var _vacuum_shape: CollisionShape2D
@export var _inventory: InventoryComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pickup_area.area_entered.connect(_on_pickup_area_entered)


func _process(delta: float) -> void:
	# vacuum server-side
	if not multiplayer.is_server():
		return

	var areas: Array = _vacuum_area.get_overlapping_areas()
	for area in areas:
		if area:
			var direction: Vector2 = (global_position - area.global_position).normalized()
			var distance: float = global_position.distance_to(area.global_position)
			var force_magnitude: float = (_vacuum_radius - distance) / _vacuum_radius * 100
			area.global_position += direction * force_magnitude * delta


func _on_pickup_area_entered(area: Area2D) -> void:
	if is_multiplayer_authority():
		if area.item and _inventory.can_add_item(area.item):
			area.on_pickup(get_parent())
