extends Camera2D

@export var target: Player
@export var target_offset: Vector2
@export var speed: float = 150


func _process(delta: float) -> void:
	if OS.has_feature("debug"):
		if not is_instance_valid(target):
			
			var direction: Vector2 = Input.get_vector("move_left", "move_right", "accelerate", "brake")
			position += direction * speed * delta

			return

	position.y = round(target.position.y + target_offset.y)
