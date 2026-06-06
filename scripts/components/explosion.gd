class_name Explosion
extends AnimatedSprite2D


func play_random_explosion() -> void:
	play(Utils.get_random_animation_name(self))
