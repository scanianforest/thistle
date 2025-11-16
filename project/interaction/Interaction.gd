@abstract
class_name Interaction extends Node

@export var interaction_resource: InteractionResource

@abstract func start(interactor: InteractorComponent) -> void

@abstract func stop(interactor: InteractorComponent) -> void

@abstract func resolve(interactor: InteractorComponent) -> void
