class_name InteractorComponent extends Node2D

@onready var _area: Area2D = %InteractorArea
@onready var _parent: Node2D = get_parent()

var _interactables_in_area: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_area.body_entered.connect(_on_body_entered)
	_area.body_exited.connect(_on_body_exited)
	_area.area_entered.connect(_on_area_entered)
	_area.area_exited.connect(_on_area_exited)

func get_parent_global_position() -> Vector2:
	return _parent.global_position

func update_direction(direction: Vector2) -> void:
	rotation = lerp_angle(rotation, direction.angle(), get_process_delta_time() * 50)


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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for interactable in _interactables_in_area:
			if interactable.has_method("interact"):
				Log.pr("Interacting with: ", interactable.name)
				interactable.interact(self)