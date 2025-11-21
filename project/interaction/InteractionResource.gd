class_name InteractionResource extends Resource

enum Type {
	INSTANT,
	TIMED,
	CONTINUOUS,
	ANIMATION,
	DIALOGUE,
}

@export var interaction_action: StringName = "interact"
@export var cancel_actions: PackedStringArray = ["ui_cancel"]
@export var type: Type = Type.INSTANT
@export var animation_name: StringName = ""
