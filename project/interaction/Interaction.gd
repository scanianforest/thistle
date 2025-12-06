@abstract
class_name Interaction extends Node

signal started
signal stopped
signal resolved
signal time_changed(new_time: float)

@export var interaction_resource: InteractionResource

@abstract func start(interactor: InteractorComponent) -> void

@abstract func stop(interactor: InteractorComponent) -> void

@abstract func resolve(interactor: InteractorComponent) -> void
