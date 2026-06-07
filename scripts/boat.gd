@tool
class_name Boat
extends Area2D

var _destroying: bool = false


@export_enum("1", "2", "3") var boat_color: String = "1":
	set(value):
		boat_color = value
		boat_sprite.animation = value
		cannon_sprite.animation = value
@export_range(-360, 360, 1) var cannon_rotation: float = 0:
	set(value):
		cannon_rotation = value
		cannon_sprite.rotation_degrees = cannon_rotation

@onready var explosion: Explosion = $Explosion
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var boat_sprite: AnimatedSprite2D = $Boat
@onready var cannon_sprite: AnimatedSprite2D = $Boat/Cannon


func _ready() -> void:
	boat_color = Utils.get_random_animation_name(boat_sprite)
	boat_sprite.play()


func _destroy() -> void:
	if _destroying:
		return
	boat_sprite.hide()
	_destroying = true
	collision_shape.set_deferred(&"disabled", true)
	explosion.play_random_explosion()
	explosion.animation_finished.connect(queue_free)


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		_destroy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
