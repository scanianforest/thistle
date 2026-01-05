class_name Game_State_InGame extends LimboState


func _enter() -> void:
	dispatch(&"started")
	dispatch(&"reveal")


func _exit() -> void:
	dispatch(&"save")
