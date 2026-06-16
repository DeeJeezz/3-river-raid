extends Node

var fuel: int = Constants.MAX_FUEL:
	set(value):
		fuel = value
		Signals.fuel_changed.emit(value)
var score: int = 0:
	set(value):
		score = value
		Signals.score_changed.emit()


func _ready() -> void:
	Signals.tick_passed.connect(_on_tick_passed)
	Signals.enemy_destroyed.connect(_on_enemy_destroyed)


func _on_enemy_destroyed(enemy: BaseEnemy) -> void:
	score += enemy.score_for_destroy


func _on_tick_passed() -> void:
	fuel -= Constants.FUEL_PER_TICK
	score += Constants.SCORE_PER_TICK

	if fuel <= 0:
		Signals.game_over.emit()


func reset() -> void:
	fuel = Constants.MAX_FUEL
	score = 0
