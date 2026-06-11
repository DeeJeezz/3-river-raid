class_name AnimatedLabel
extends RichTextLabel

const BB_CODE: String = "[color=%s]%s[/color]"

@export var letter_change_speed: float = 0.25
@export var color: Color = Color.RED

var _time_passed: float
var _current_index: int = 0
var _original_text: String


func _ready() -> void:
	_original_text = text
	_time_passed = letter_change_speed


func _process(delta: float) -> void:
	if _time_passed <= letter_change_speed:
		_time_passed += delta
		return
	_time_passed = 0
	_color_next_letter()


func _color_next_letter() -> void:
	var next_letter: String = _original_text[_current_index]
	if not next_letter.lstrip(' '):
		_current_index += 1
		_color_next_letter()
		return

	var before_text: String = _original_text.substr(0, _current_index)
	var after_text: String = _original_text.substr(_current_index + 1, _original_text.length())

	text = before_text + BB_CODE % [color.to_html(), next_letter] + after_text

	if _current_index == _original_text.length() - 1:
		_current_index = 0
		return
	_current_index += 1
