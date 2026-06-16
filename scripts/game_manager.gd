class_name GameManager
extends Node2D

@export var game_over_screen: CanvasLayer


func _ready() -> void:
	Signals.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	game_over_screen.show()
