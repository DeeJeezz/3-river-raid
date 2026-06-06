extends Area2D

var _destroying: bool = false

@onready var explosion: Explosion = $Explosion
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shadow_sprite: Sprite2D = $Shadow


func _ready() -> void:
	animated_sprite.play(Utils.get_random_animation_name(animated_sprite))


func _destroy() -> void:
	if _destroying:
		return
	animated_sprite.hide()
	shadow_sprite.hide()
	_destroying = true
	collision_shape.set_deferred(&"disabled", true)
	explosion.play_random_explosion()
	explosion.animation_finished.connect(queue_free)


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		_destroy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
