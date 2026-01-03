class_name EntityManager extends Node2D

@onready
var chest_container_scene: PackedScene = preload("res://placeables/item_container/chest/chest.tscn")


func _enter_tree() -> void:
	LimboConsole.register_command(
		_command_spawn_container,
		"entities_spawn_container",
		"Spawns an item container at the player's position."
	)


func _exit_tree() -> void:
	LimboConsole.unregister_command(_command_spawn_container)


func _ready() -> void:
	clear()


func clear() -> void:
	for child in get_children():
		child.queue_free()


func save(world_data: WorldData) -> void:
	var entities_data = EntitiesData.new()
	for entity in get_children():
		if entity is ItemContainer:
			var container_data := ContainerData.new()
			container_data.position = entity.global_position
			container_data.items = entity.inventory.items.duplicate()
			entities_data.containers.append(container_data)

	world_data.entities = entities_data


func load(entities: EntitiesData) -> void:
	for container in entities.containers:
		spawn_container(container)


func spawn_container(container_data: ContainerData) -> void:
	var container: ItemContainer = chest_container_scene.instantiate()
	add_child(container)
	container.global_position = container_data.position
	container.inventory.items = container_data.items


func is_entity(node: Node) -> bool:
	return node.get("resource") and node.resource is EntityResource


func _command_spawn_container(spawn_pos: Vector2) -> void:
	var container: ItemContainer = chest_container_scene.instantiate()
	add_child(container)
	container.global_position = spawn_pos
