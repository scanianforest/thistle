class_name OpenContainerInteration extends InteractionComponent

@export var inventory: InventoryComponent


func interact(_interactor: Node) -> void:
	UIChannel.open_container(inventory)
