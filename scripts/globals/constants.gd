extends Node


const MAIN_MENU_SCENE_PATH: String = "res://scenes/ui/main_menu.tscn"
const GAME_SCENE_PATH: String = "res://scenes/levels/level1.tscn"

const TILE_SIZE: int = 16
const PLAYER_GROUP_NAME: StringName = &"Player"

var SCREEN_SIZE: Vector2

var SCORE_PER_TICK: int = 10
var FUEL_PER_TICK: int = 5
var MAX_FUEL: int = 100


func _ready() -> void:
	SCREEN_SIZE = get_viewport().get_visible_rect().size
