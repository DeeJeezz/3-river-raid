@abstract
class_name Pickable
extends Area2D


func _ready() -> void:
	area_entered.connect(pickup)


@abstract func pickup(area: Area2D) -> void
