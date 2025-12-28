class_name OpenContainerInteraction extends Interaction

@export var inventory: InventoryComponent


func start(interactor: InteractorComponent) -> void:
	var interactor_inventory: InventoryComponent = interactor.get_sibling_component(
		"InventoryComponent"
	)

	if inventory == null:
		Log.err("ItemContainer has no InventoryComponent, cannot open container")
		return

	if interactor_inventory == null:
		Log.err("Interacting parent has no InventoryComponent, cannot open container")
		return

	UIChannel.open_container(inventory)
	interactor_inventory.open()

	started.emit()


func stop(interactor: InteractorComponent) -> void:
	var interactor_inventory: InventoryComponent = interactor.get_sibling_component(
		"InventoryComponent"
	)

	if inventory == null:
		Log.err("ItemContainer has no InventoryComponent, cannot open container")
		return

	if interactor_inventory == null:
		Log.err(
			(
				"Interacting parent %s has no InventoryComponent, cannot open container"
				% interactor._parent.name
			)
		)
		return

	UIChannel.close_container()
	interactor_inventory.close()

	stopped.emit()


func resolve(_interactor: InteractorComponent) -> void:
	pass
