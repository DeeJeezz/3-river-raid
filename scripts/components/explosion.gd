class_name Explosion
extends AnimatedSprite2D

var _animation_names: PackedStringArray


func _ready() -> void:
	_animation_names = sprite_frames.get_animation_names()


func play_random_explosion() -> void:
	play(_get_random_animation_name())


func _get_random_animation_name() -> StringName:
	return _animation_names[randi() % _animation_names.size()]
