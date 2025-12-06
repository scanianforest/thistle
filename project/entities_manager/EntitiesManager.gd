class_name EntitiesManager extends Node2D

@onready
var chest_container_scene: PackedScene = preload("res://placeables/item_container/chest/chest.tscn")


func _ready() -> void:
	LimboConsole.register_command(
		_command_spawn_container,
		"entities_spawn_container",
		"Spawns an item container at the player's position."
	)

	clear()


func clear() -> void:
	for entity in get_children():
		entity.queue_free()


func save(world_data: WorldData) -> void:
	var entities_data = EntitiesData.new()
	for entity in get_children():
		if entity is ItemContainer:
			var container_data := ContainerData.new()
			container_data.position = entity.global_position
			container_data.items = entity.inventory.items.duplicate()
			entities_data.containers.append(container_data)

	world_data.entities = entities_data


func load(world_data: WorldData) -> void:
	for container in world_data.entities.containers:
		spawn_container(container)


func spawn_container(container_data: ContainerData) -> void:
	var container: ItemContainer = chest_container_scene.instantiate()
	add_child(container)
	container.global_position = container_data.position
	container.inventory.items = container_data.items


func _command_spawn_container(spawn_pos: Vector2) -> void:
	var container: ItemContainer = chest_container_scene.instantiate()
	add_child(container)
	container.global_position = spawn_pos
