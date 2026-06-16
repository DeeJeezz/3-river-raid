class_name Player
extends Area2D

const ACCELERATION: float = 150.0
const DEFAULT_ANIMATION_SPEED: float = 1.0

@export_category("Horizontal movement settings")
@export var horizontal_speed: float = 150
@export_category("Vertical movement settings")
@export var vertical_speed: float = 150
@export var acceleration_speed: float = 300
@export var braking_speed: float = 100
@export_category("Shooting settings")
@export var bullet_scene: PackedScene
@export_range(0, 5, 0.05) var shoot_cooldown: float = 0.75
@export var shooting_timer: Timer
@export_category("Animation settings")
@export var return_to_idle_animation_speed: float = -3.0
@export var acceleration_animation_speed: float = 3.0
@export_category("Debug")
@export var debug_controls: bool = false

var _can_shoot: bool = true
var _target_speed: float
var _speed: float
var _previous_captured_position_y: float
var _previous_direction: float = 0
var _current_animation_speed: float = DEFAULT_ANIMATION_SPEED

@onready var plane_sprite: AnimatedSprite2D = $Plane
@onready var shadow_sprite: AnimatedSprite2D = $Plane/Shadow
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var explosion: Explosion = $Explosion


func _ready() -> void:
	_previous_captured_position_y = position.y
	_speed = vertical_speed
	_target_speed = _speed
	plane_sprite.play(&"idle")
	shooting_timer.timeout.connect(func (): _can_shoot = true)


func _process(delta: float) -> void:
	_handle_input(delta)
	_change_speed(delta)


func destroy() -> void:
	shooting_timer.stop()
	_can_shoot = false
	collision_shape.set_deferred(&"disabled", true)
	_speed = 0
	_target_speed = 0
	horizontal_speed = 0
	plane_sprite.hide()
	explosion.play_random_explosion()
	explosion.animation_finished.connect(queue_free)


func _play_turn_animation(direction: float) -> void:
	if direction != _previous_direction:
		if plane_sprite.animation_finished.is_connected(plane_sprite.play):
			plane_sprite.animation_finished.disconnect(plane_sprite.play)
		if shadow_sprite.animation_finished.is_connected(shadow_sprite.play):
			shadow_sprite.animation_finished.disconnect(shadow_sprite.play)
		
		if direction < 0:
			plane_sprite.play(&"turn_left", _current_animation_speed)
			plane_sprite.animation_finished.connect(plane_sprite.play.bind(&"left_idle", _current_animation_speed))

			shadow_sprite.play(&"turn_left", _current_animation_speed)
			shadow_sprite.animation_finished.connect(shadow_sprite.play.bind(&"left_idle", _current_animation_speed))

			collision_shape.scale.x = 0.5
		elif direction > 0:
			plane_sprite.play(&"turn_right", _current_animation_speed)
			plane_sprite.animation_finished.connect(plane_sprite.play.bind(&"right_idle", _current_animation_speed))

			shadow_sprite.play(&"turn_right", _current_animation_speed)
			shadow_sprite.animation_finished.connect(shadow_sprite.play.bind(&"right_idle", _current_animation_speed))

			collision_shape.scale.x = 0.5
		else:
			if _previous_direction < 0:
				plane_sprite.play(&"turn_left", return_to_idle_animation_speed * _current_animation_speed, true)
				shadow_sprite.play(&"turn_left", return_to_idle_animation_speed * _current_animation_speed, true)
			elif _previous_direction > 0:
				plane_sprite.play(&"turn_right", return_to_idle_animation_speed * _current_animation_speed, true)
				shadow_sprite.play(&"turn_right", return_to_idle_animation_speed * _current_animation_speed, true)
			plane_sprite.animation_finished.connect(plane_sprite.play.bind(&"idle", _current_animation_speed))
			shadow_sprite.animation_finished.connect(shadow_sprite.play.bind(&"idle", _current_animation_speed))
			collision_shape.scale.x = 1

	_previous_direction = direction


func _move(direction: float, delta: float) -> void:

	_play_turn_animation(direction)

	position.x += direction * horizontal_speed * delta

	if debug_controls:
		var vertical_direction: float = Input.get_axis("accelerate", "brake")
		position.y += _speed * delta * vertical_direction
	else:
		position.y -= _speed * delta
		if abs(abs(position.y) - abs(_previous_captured_position_y)) >= 100:
			Signals.tick_passed.emit()
			_previous_captured_position_y = position.y
			if Session.fuel <= 0:
				_target_speed = 0
				vertical_speed = 0

	_clamp_position()


func _shoot() -> void:
	if not _can_shoot:
		return
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.position.y -= 10
	get_tree().current_scene.add_child(bullet)
	_can_shoot = false
	shooting_timer.start(shoot_cooldown)


func _change_speed(delta: float) -> void:
	if _target_speed != _speed:
		_speed = move_toward(_speed, _target_speed, ACCELERATION * delta)


func _handle_input(delta: float) -> void:

	var direction: float = Input.get_axis("move_left", "move_right")
	_move(direction, delta)

	if debug_controls:
		return

	if Input.is_action_pressed(&"shoot"):
		_shoot()

	if Input.is_action_pressed(&"accelerate"):
		_target_speed = acceleration_speed
		_current_animation_speed = acceleration_animation_speed
	elif Input.is_action_just_released(&"accelerate"):
		_target_speed = vertical_speed
		_current_animation_speed = DEFAULT_ANIMATION_SPEED
	elif Input.is_action_pressed(&"brake"):
		_target_speed = braking_speed
		_current_animation_speed = DEFAULT_ANIMATION_SPEED * 0.75
	elif Input.is_action_just_released(&"brake"):
		_target_speed = vertical_speed
		_current_animation_speed = DEFAULT_ANIMATION_SPEED


func _clamp_position() -> void:
	position.x = clampf(position.x, 0, Constants.SCREEN_SIZE.x)


func _on_body_entered(_body: Node2D) -> void:
	destroy()


func _on_area_entered(_area: Area2D) -> void:
	destroy()
