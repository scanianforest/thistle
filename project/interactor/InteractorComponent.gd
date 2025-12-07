class_name InteractorComponent extends Node2D

signal started(interaction: InteractionResource)
signal resolved
signal stopped

@onready var _area: Area2D = %InteractorArea
@export var _parent: Node2D = get_parent()

var _interactables_in_area: Array = []

var current_interaction: Interaction = null

var _closest_interactable: Node = null:
	set(value):
		if _closest_interactable:
			_closest_interactable.on_deselected()

		_closest_interactable = value
		if _closest_interactable != null:
			_closest_interactable.on_selected()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)
	_area.area_entered.connect(_on_area_entered)
	_area.area_exited.connect(_on_area_exited)


func _process(_delta: float) -> void:
	if _interactables_in_area.size() == 0:
		_closest_interactable = null
	else:
		_closest_interactable = get_closest_interactable()


func get_sibling_component(component_type) -> Node:
	for sibling in _parent.get_children():
		if sibling.get_script() == null:
			continue
		if sibling.get_script().get_global_name() == component_type:
			return sibling
	return null


func get_parent_global_position() -> Vector2:
	return _parent.global_position


func _on_body_entered(body: Node) -> void:
	Log.pr("Body entered interaction area: ", body.name)
	_interactables_in_area.push_back(body)


func _on_body_exited(body: Node) -> void:
	Log.pr("Body exited interaction area: ", body.name)
	_interactables_in_area.erase(body)


func _on_area_entered(area: Area2D) -> void:
	Log.pr("Area entered interaction area: ", area.name)
	_interactables_in_area.push_back(area)


func _on_area_exited(area: Area2D) -> void:
	Log.pr("Area exited interaction area: ", area.name)
	_interactables_in_area.erase(area)


func get_closest_interactable() -> Node2D:
	var closest_interactable: Node2D = null
	var closest_distance: float = INF

	for interactable in _interactables_in_area:
		var distance = interactable.global_position.distance_to(_area.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_interactable = interactable
	return closest_interactable


func interact() -> Interaction:
	for interactable in _interactables_in_area:
		if interactable.interaction:
			started.emit(interactable.interaction)
			current_interaction = interactable.interaction
			return interactable.interaction
	return null


func resolve() -> void:
	if current_interaction == null:
		Log.err("No current interactable to resolve interaction with")
		return
	resolved.emit()
	current_interaction.resolve(self)
	current_interaction = null


func stop_interaction() -> void:
	Log.pr("Stopping interaction", current_interaction)
	if current_interaction == null:
		Log.err("No current interactable to stop interaction with")
		return
	current_interaction.stop(self)
	stopped.emit()
	current_interaction = null
