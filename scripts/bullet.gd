class_name Bullet
extends Area2D

const SPEED: float = 450.0


func _process(delta: float) -> void:
	position.y -= SPEED * delta


func _on_area_entered(_area: Area2D) -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
