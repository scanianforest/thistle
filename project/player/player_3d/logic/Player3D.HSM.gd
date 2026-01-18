class_name Player3D_HSM extends LimboHSM

@export var logging: bool = false

@export var idling: LimboState
@export var moving: LimboState
@export var jumping: LimboState
@export var falling: LimboState


func _ready() -> void:
	active_state_changed.connect(_on_active_state_changed)


func _on_active_state_changed(current: LimboState, old: LimboState) -> void:
	if logging:
		var old_name: String = old.name if old != null else &"None"
		Log.pr("%s -> %s" % [old_name, current.name])
