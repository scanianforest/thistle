extends Area2D

@export var interaction: Interaction

var _tween: Tween
var _jiggle: Tween


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if body is Player:
		Log.pr("Player entered bush area")
		_tween = create_tween()
		_tween.tween_property($Sprite, "modulate:a", 0.6, 0.5)
		_jiggle = create_tween()
		_jiggle.tween_property($Sprite, "rotation_degrees", 5, 0.1)
		_jiggle.tween_property($Sprite, "rotation_degrees", -5, 0.1)
		_jiggle.tween_property($Sprite, "rotation_degrees", 0, 0.1)
		$LeafRustleParticles.restart()


func _on_body_exited(body: Node) -> void:
	if body is Player:
		Log.pr("Player exited bush area")
		_tween = create_tween()
		_tween.tween_property($Sprite, "modulate:a", 1.0, 0.5)
