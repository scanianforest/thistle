extends InteractionComponent

var tween: Tween

func interact(interactor: InteractorComponent) -> void:
	if tween and tween.is_running():
		return
	Log.pr("Picked up item by interactor: ", interactor.name)
	PlayerChannel.on_inventory_updated([self.name])
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "global_position", interactor.get_parent_global_position(), 0.1)
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)