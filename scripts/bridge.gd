class_name Bridge
extends Area2D

var _hp: int = 3

@onready var explosion: Explosion = $Explosion
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _destroy() -> void:
	collision_shape.set_deferred("disabled", true)
	sprite.hide()
	explosion.play_random_explosion()
	explosion.animation_finished.connect(queue_free)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(_area: Area2D) -> void:
	_hp -= 1
	if _hp <= 0:
		_destroy()
