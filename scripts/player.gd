class_name Player
extends Area2D

const ACCELERATION: float = 150.0

@export_category("Horizontal movement settings")
@export var horizontal_speed: float
@export_category("Vertical movement settings")
@export var vertical_speed: float
@export var acceleration_speed: float
@export var braking_speed: float
@export_category("Shooting settings")
@export_range(0.5, 5, 0.05) var shoot_cooldown: float = 0.25

var _can_shoot: bool = true
var _target_speed: float
var _speed: float

@onready var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var explosion: AnimatedSprite2D = $Explosion


func _ready() -> void:
	_speed = vertical_speed
	_target_speed = _speed
	animated_sprite.play(&"idle")


func _process(delta: float) -> void:
	_handle_input(delta)
	_change_speed(delta)


func destroy() -> void:
	collision_shape.set_deferred("disabled", true)
	_speed = 0
	_target_speed = 0
	horizontal_speed = 0
	animated_sprite.hide()
	var animation_names: PackedStringArray = explosion.sprite_frames.get_animation_names()
	var random_explosion: String = animation_names[randi() % animation_names.size()]
	explosion.play(random_explosion)
	explosion.animation_finished.connect(queue_free)


func _move(direction: float, delta: float) -> void:

	position.x += direction * horizontal_speed * delta
	position.y -= _speed * delta

	_clamp_position()


func _shoot() -> void:
	if not _can_shoot:
		return
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.position.y -= 10
	get_tree().current_scene.add_child(bullet)
	_can_shoot = false
	get_tree().create_timer(shoot_cooldown).timeout.connect(func(): _can_shoot = true)


func _change_speed(delta: float) -> void:
	if _target_speed != _speed:
		_speed = move_toward(_speed, _target_speed, ACCELERATION * delta)


func _handle_input(delta: float) -> void:
	var direction: float = Input.get_axis(&"move_left", &"move_right")
	_move(direction, delta)

	if Input.is_action_pressed(&"shoot"):
		_shoot()

	if Input.is_action_pressed(&"accelerate"):
		_target_speed = acceleration_speed
		animated_sprite.play(&"accelerate")
	elif Input.is_action_just_released(&"accelerate"):
		_target_speed = vertical_speed
		animated_sprite.play(&"idle")
	elif Input.is_action_pressed(&"brake"):
		_target_speed = braking_speed
		animated_sprite.play(&"brake")
	elif Input.is_action_just_released(&"brake"):
		_target_speed = vertical_speed
		animated_sprite.play(&"idle")


func _clamp_position() -> void:
	position.x = clampf(position.x, 0, Constants.SCREEN_SIZE.x)


func _on_body_entered(_body: Node2D) -> void:
	destroy()


func _on_area_entered(_area: Area2D) -> void:
	destroy()
