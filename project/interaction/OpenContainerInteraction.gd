class_name OpenContainerInteration extends InteractionComponent

@export var inventory: InventoryComponent


func interact(_interactor: Node) -> void:
	UIChannel.open_container(inventory)


func get_animation_name() -> StringName:
	return "open_container"
