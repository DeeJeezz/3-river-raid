class_name Bullet
extends Area2D

const SPEED: float = 400.0


func _process(delta: float) -> void:
	position.y -= SPEED * delta


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
