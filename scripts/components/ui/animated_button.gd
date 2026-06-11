class_name AnimatedButton
extends Button


@export var hover_scale: Vector2 = Vector2(1.025, 1.0125)
@export_range(0, 1, 0.01) var animation_duration: float = 0.05


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	
func _on_mouse_entered() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale:x", 1.025, 0.1)
	tween.tween_property(self, "scale:y", 1.0125, 0.1)
	
	
func _on_mouse_exited() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale:x", 1, 0.1)
	tween.tween_property(self, "scale:y", 1, 0.1)
