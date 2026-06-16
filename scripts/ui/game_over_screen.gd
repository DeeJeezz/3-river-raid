extends CanvasLayer


@export var score_label: Label


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	
	
func _on_visibility_changed() -> void:
	if visible:
		score_label.text = "Score: %d" % Session.score


func _on_restart_button_button_down() -> void:
	Session.reset()
	Signals.scene_change.emit(Constants.GAME_SCENE_PATH)


func _on_main_menu_button_button_down() -> void:
	Signals.scene_change.emit(Constants.MAIN_MENU_SCENE_PATH)
	queue_free()
