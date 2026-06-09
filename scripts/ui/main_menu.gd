extends CanvasLayer


func _on_play_button_button_down() -> void:
	Signals.scene_change.emit(Constants.GAME_SCENE_PATH)
	queue_free()


func _on_quit_button_button_down() -> void:
	get_tree().quit()
