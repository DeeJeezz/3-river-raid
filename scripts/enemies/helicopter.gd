class_name Helicopter
extends Area2D

var _destroying: bool = false

@onready var explosion: Explosion = $Explosion
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Body


func _destroy() -> void:
	if _destroying:
		return
	sprite.hide()
	_destroying = true
	collision_shape.set_deferred(&"disabled", true)
	explosion.play_random_explosion()
	explosion.animation_finished.connect(queue_free)


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		_destroy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
