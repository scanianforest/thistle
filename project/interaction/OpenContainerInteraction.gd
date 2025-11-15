class_name OpenContainerInteraction extends InteractionComponent

@export var inventory: InventoryComponent


func _ready() -> void:
	animation_name = "open_container"
	interaction_type = InteractionType.INSTANT


func interact(_interactor: Node) -> void:
	UIChannel.open_container(inventory)


func get_animation_name() -> StringName:
	return "open_container"
