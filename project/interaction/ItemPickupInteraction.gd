class_name ItemPickupInteraction extends Interaction

var item: ItemData

var tween: Tween


func start(_interactor: InteractorComponent) -> void:
	pass


func resolve(interactor: InteractorComponent) -> void:
	if tween and tween.is_running():
		return
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		get_parent(), "global_position", interactor.get_parent_global_position(), 0.1
	)
	tween.tween_property(get_parent(), "modulate:a", 0.0, 0.1)
	tween.set_parallel(false)
	tween.tween_callback(
		func():
			var inventory: InventoryComponent = interactor.get_sibling_component(
				"InventoryComponent"
			)
			if inventory:
				inventory.add_item(item)
			else:
				Log.err("Interacting parent has no InventoryComponent, cannot add item")
	)
	tween.tween_callback(queue_free)


func stop(_interactor: InteractorComponent) -> void:
	pass
