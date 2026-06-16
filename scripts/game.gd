extends Node2D


func _ready() -> void:
	Signals.scene_change.connect(_load_scene)
	Signals.scene_change.emit(Constants.MAIN_MENU_SCENE_PATH)


func _load_scene(scene_path: String) -> void:
	for child in get_children():
		child.queue_free()
	var scene: PackedScene = load(scene_path)
	add_child(scene.instantiate())
