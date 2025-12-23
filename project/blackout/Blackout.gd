class_name Blackout extends Control

var _tween: Tween


func blackout(duration: float = 0.5) -> void:
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", 1.0, duration)
	await _tween.finished


func reveal(duration: float = 0.25) -> void:
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", 0.0, duration)
	await _tween.finished
