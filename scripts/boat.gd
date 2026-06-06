extends Area2D

@onready var explosion: Explosion = $Explosion
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


var _destroying: bool = false


func _destroy() -> void:
	if _destroying:
		return
	_destroying = true
	collision_shape.set_deferred(&"disabled", true)
	sprite.hide()
	explosion.play_random_explosion()
	explosion.animation_finished.connect(queue_free)


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		_destroy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
