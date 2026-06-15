class_name AnimatedButton
extends Button

@export var hover_scale: Vector2 = Vector2(1.025, 1.025)
@export_range(0, 10, 0.05) var hover_rotation: float = 0.25
@export_range(0, 1, 0.01) var animation_duration: float = 0.05


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	pivot_offset = Vector2(size.x / 2, size.y / 2)


func _on_mouse_entered() -> void:
	var random_direction: int = [-1, 1].pick_random()
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", hover_scale, animation_duration)
	tween.tween_property(self, "rotation_degrees", hover_rotation * random_direction, animation_duration)


func _on_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE, animation_duration)
	tween.tween_property(self, "rotation_degrees", 0, animation_duration)
