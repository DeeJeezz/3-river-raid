class_name EnemySpawner
extends Node2D

@export var boat_scenes: Array[PackedScene]
@export var helicopter_scenes: Array[PackedScene]


func spawn_boat(pos: Vector2, degrees_rotation: float) -> void:
	_spawn_enemy(boat_scenes, pos, degrees_rotation)
	prints("Spawned boat:", pos)


func spawn_helicopter(pos: Vector2, degrees_rotation: float) -> void:
	_spawn_enemy(helicopter_scenes, pos, degrees_rotation)
	prints("Spawned helicopter:", pos)


func _spawn_enemy(enemy_scenes: Array[PackedScene], enemy_position: Vector2, enemy_rotation_degrees: float) -> void:
	var enemy_scene: PackedScene = enemy_scenes.pick_random()
	var enemy: Area2D = enemy_scene.instantiate()
	enemy.position = enemy_position
	enemy.rotation_degrees = enemy_rotation_degrees
	add_child(enemy)
