class_name PulsatingLabel
extends Label

@export_range(0, 2, 0.05) var pulse_duraion: float = 0.25
@export var pulse_color: Color = Color.RED

var _initial_color: Color


func _ready() -> void:
	_initial_color = get_theme_color("font_color")
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "theme_override_colors/font_color", pulse_color, pulse_duraion)
	tween.tween_property(self, "theme_override_colors/font_color", _initial_color, pulse_duraion)
