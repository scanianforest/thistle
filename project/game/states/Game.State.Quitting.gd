class_name Game_State_Quitting extends LimboState


func _enter() -> void:
	get_tree().quit()
