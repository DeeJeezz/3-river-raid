extends Node

const TILE_SIZE: int = 16

var SCREEN_SIZE: Vector2


func _ready() -> void:
	SCREEN_SIZE = get_viewport().get_visible_rect().size
