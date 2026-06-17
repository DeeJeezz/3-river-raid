class_name BaseEnemy
extends Area2D

@export_category("Settings")
@export var score_for_destroy: int = 100

@export_category("Nodes")
@export var sprite: Node2D
@export var collision_shape: CollisionShape2D
@export var explosion: Explosion
@export var visible_on_screen_notifier: VisibleOnScreenNotifier2D

var _destroying: bool = false

var _target: Player


func _ready() -> void:
	_target = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP_NAME)
	area_entered.connect(_on_area_entered)
	visible_on_screen_notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)


func _destroy() -> void:
	if _destroying:
		return
	sprite.hide()
	Signals.enemy_destroyed.emit(self)
	_destroying = true
	collision_shape.set_deferred(&"disabled", true)
	explosion.play_random_explosion()
	explosion.animation_finished.connect(queue_free)


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		_destroy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
