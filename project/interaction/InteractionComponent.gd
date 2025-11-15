@abstract
class_name InteractionComponent extends Node

enum InteractionType { INSTANT, TIMED, CONTINUOUS }

var animation_name: StringName = ""
var interaction_type: InteractionType = InteractionType.INSTANT

@abstract func interact(interactor: InteractorComponent) -> void
