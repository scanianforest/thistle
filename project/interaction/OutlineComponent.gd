class_name OutlineComponent extends Node

@onready var sprite: Sprite2D = $"./.."


func _ready() -> void:
	fade_out_outline()


func fade_in_outline() -> void:
	var shader_mat = sprite.material as ShaderMaterial
	shader_mat.set_shader_parameter("color", Color(1, 1, 1, 0.75))


func fade_out_outline() -> void:
	var shader_mat = sprite.material as ShaderMaterial
	shader_mat.set_shader_parameter("color", Color(1, 1, 1, 0))
