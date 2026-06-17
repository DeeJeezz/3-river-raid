class_name Boat
extends BaseEnemy

@export_range(0, 1, 0.005) var cannon_rotation_speed: float = 0.025

var boat_color: String = "1":
	set(value):
		boat_color = value
		boat_sprite.animation = value
		cannon_sprite.animation = value

var cannon_rotation: float = 0:
	set(value):
		cannon_rotation = value
		cannon_sprite.rotation_degrees = cannon_rotation

@onready var boat_sprite: AnimatedSprite2D = $Sprites/Boat
@onready var cannon_sprite: AnimatedSprite2D = $Sprites/Boat/Cannon


func _ready() -> void:
	super._ready()
	boat_color = Utils.get_random_animation_name(boat_sprite)
	boat_sprite.play()


func _process(_delta: float) -> void:
	if not is_instance_valid(_target):
		return

	cannon_rotation = rad_to_deg(
		lerp_angle(
			deg_to_rad(cannon_rotation),
			get_angle_to(_target.global_position),
			cannon_rotation_speed,
		),
	)
