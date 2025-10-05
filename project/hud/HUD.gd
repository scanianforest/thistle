class_name HUD extends Control

@export var health_bar: ProgressBar

func _ready() -> void:
	PlayerChannel.health_changed.connect(_on_health_changed)
	PlayerChannel.max_health_changed.connect(_on_max_health_changed)
	PlayerChannel.died.connect(_on_died)

func _on_health_changed(new_health: int) -> void:
	health_bar.value = new_health

func _on_max_health_changed(new_max_health: int) -> void:
	health_bar.max_value = new_max_health

func _on_died() -> void:
	health_bar.value = 0
