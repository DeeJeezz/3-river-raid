extends Pickable
class_name FuelBarrel


@export var fuel: int = 10

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var explosion: Explosion = $Explosion


func _destroy() -> void:
	collision_shape.set_deferred("disabled", true)
	sprite.hide()
	explosion.play_random_explosion()
	explosion.animation_finished.connect(queue_free)


func pickup(area: Area2D) -> void:
	if area is Bullet:
		_destroy()
	elif area is Player:
		Session.fuel += fuel
		queue_free()
