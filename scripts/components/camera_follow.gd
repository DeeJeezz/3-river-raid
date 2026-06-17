extends Camera2D

@export var target: Player
@export var target_offset: Vector2
@export var speed: float = 300

var _can_move: bool = true


func _ready() -> void:
	Signals.game_over.connect(func(): _can_move = false)


func _process(delta: float) -> void:
	if OS.has_feature("debug"):
		if not is_instance_valid(target):

			var direction: Vector2 = Input.get_vector("move_left", "move_right", "accelerate", "brake")
			position += direction * speed * delta

			return

	if not _can_move:
		return

	position.y = floori(move_toward(position.y, target.position.y + target_offset.y, speed * delta))
