class_name HUD
extends CanvasLayer

@export_category("Nodes")
@export var score_label: Label
@export var fuel_progress_bar: TextureProgressBar
@export_category("Animation settings")
@export_range(0, 1, 0.05) var score_animation_duration: float = 0.1
@export_range(0, 1, 0.05) var fuel_animation_duration: float = 0.2


func _ready() -> void:
	Signals.fuel_changed.connect(_on_fuel_changed)
	Signals.score_changed.connect(_on_score_changed)
	_set_score_label_value(Session.score)
	fuel_progress_bar.max_value = Session.fuel
	fuel_progress_bar.value = fuel_progress_bar.max_value


func _on_score_changed() -> void:
	var tween: Tween = create_tween()
	tween.tween_method(_set_score_label_value, int(score_label.text), Session.score, score_animation_duration)


func _on_fuel_changed(value: int) -> void:
	_set_fuel_progress_bar_value(value)

	
func _set_fuel_progress_bar_value(value: int) -> void:
	fuel_progress_bar.value = value


func _set_score_label_value(value: int) -> void:
	score_label.text = "%d" % value
