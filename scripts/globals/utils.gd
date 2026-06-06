extends Node


func get_random_animation_name(animated_sprite: AnimatedSprite2D) -> StringName:
	var animation_names: PackedStringArray = animated_sprite.sprite_frames.get_animation_names()
	return animation_names[randi() % animation_names.size()]
