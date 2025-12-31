extends SubViewportContainer


func _unhandled_input(event: InputEvent) -> void:
	Log.debug("Input event received: %s" % event)
