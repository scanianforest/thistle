class_name Game_State_Running extends LimboState


func _enter() -> void:
	dispatch(&"started")


func _exit() -> void:
	dispatch(&"stopped")
