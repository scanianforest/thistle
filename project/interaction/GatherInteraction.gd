extends Interaction

@export var item_resource: ItemResource

var _timer: SceneTreeTimer


func start(interactor: InteractorComponent) -> void:
	Log.pr("Starting GatherInteraction")
	started.emit()

	_timer = get_tree().create_timer(interaction_resource.time)
	await _timer.timeout

	resolve(interactor)


func _process(_delta: float) -> void:
	if _timer and _timer.time_left > 0:
		var elapsed_time: float = interaction_resource.time - _timer.time_left
		var progress: float = elapsed_time / interaction_resource.time
		time_changed.emit(progress)


func stop(_interactor: InteractorComponent) -> void:
	stopped.emit()


func resolve(interactor: InteractorComponent) -> void:
	var inventory: InventoryComponent = interactor.get_sibling_component("InventoryComponent")
	if inventory == null:
		Log.err("Interactor has no InventoryComponent, cannot gather item")
		return

	var item_instance: ItemData = ItemData.new(item_resource)
	var added: bool = inventory._add_item(item_instance)
	if not added:
		Log.err("Could not add gathered item to inventory")
		return

	resolved.emit()
