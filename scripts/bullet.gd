class_name Bullet
extends Area2D

const SPEED: float = 450.0

@onready var shadow_sprite: Sprite2D = $Sprite2D/Shadow


func _process(delta: float) -> void:
	position.y -= SPEED * delta
	shadow_sprite.position = shadow_sprite.position.move_toward(Vector2(-1, 3), 5 * delta)


func _on_area_entered(_area: Area2D) -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
