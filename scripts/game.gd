extends Node2D


func _ready() -> void:
	Signals.scene_change.connect(_load_scene)


func _load_scene(scene_path: String) -> void:
	var scene: PackedScene = load(scene_path)
	add_child(scene.instantiate())
