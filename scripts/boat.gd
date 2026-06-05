extends Area2D

@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	visible_on_screen_notifier.screen_exited.connect(_destroy)


func _destroy() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		_destroy()
