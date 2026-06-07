class_name LevelGenerator
extends Node2D

const SOURCE_ID: int = 1
const TERRAIN_SET: int = 0
const GROUND_TERRAIN: int = 0
const WATER_TERRAIN: int = 1

@export_category("Camera settings")
@export var camera: Camera2D

@export_category("Tilemap settings")
@export var tile_map: TileMapLayer

@export_category("Generator settings")
@export var game_seed: int = 0
@export var seed_label: Label
@export var random_seed: bool = false
@export var chunk_size: int = 8
@export var delete_after_rows: int = 8
@export_group("River settings")
@export var min_river_width: int = 14
@export var max_river_width: int = 20
@export_group("Segment settings")
@export var min_segment_length: int = 4
@export var max_segment_length: int = 16

@export_category("Spawner settings")
@export var enemy_spawner: EnemySpawner
@export var do_not_spawn_until_row: int = 30
@export var spawn_threshold_rows: int = 8
@export_group("River enemies")
@export_subgroup("Boats", "boat")
@export_range(0, 1, 0.01) var boat_possibility: float = 0.2
@export_group("Air enemies")
@export_subgroup("Helicopters", "helicopter")
@export_range(0, 1, 0.01) var helicopter_possibility: float = 0.2

var _river_center: int
var _river_width: int
var _preloaded_rows_on_y: int
var _tile_map_width: int
var _tile_map_height: int

var _segment_rows_left: int = 0
var _enemy_spawned_last_row: int = 0


func _ready() -> void:
	if random_seed:
		game_seed = randi()
	seed(game_seed)
	seed_label.text = "seed: %d" % game_seed

	_tile_map_width = ceili(Constants.SCREEN_SIZE.x / Constants.TILE_SIZE)
	_tile_map_height = ceili(Constants.SCREEN_SIZE.y / Constants.TILE_SIZE)
	_river_center = floori(_tile_map_width * 0.5)
	_river_width = randi_range(min_river_width, max_river_width)

	# On level ready preload rows starting from -2 "y" coord.
	_preload_chunk(-2)
	
	for y in range(_tile_map_height, -1, -chunk_size):
		_generate_chunk(y)


func _process(_delta: float) -> void:
	_check_need_to_preload_rows()
	_check_need_to_delete_rows()


func _preload_chunk(start_y: int) -> void:
	_generate_chunk(start_y)
	_preloaded_rows_on_y = start_y - chunk_size
	prints("Preloaded chunk", _preloaded_rows_on_y)


func _check_need_to_preload_rows() -> void:
	var tile_map_camera_position: Vector2i = tile_map.local_to_map(camera.position)
	if abs(abs(_preloaded_rows_on_y) - abs(tile_map_camera_position.y)) < 30:
		_preload_chunk(_preloaded_rows_on_y)


func _check_need_to_delete_rows() -> void:
	var screen_bottom_tile_map_position: Vector2i = tile_map.local_to_map(camera.position)
	var y: int = screen_bottom_tile_map_position.y + floori(_tile_map_height * 0.5)
	for x in range(_tile_map_width):
		tile_map.erase_cell(Vector2i(x, y + delete_after_rows))

	
func _generate_chunk(start_y: int) -> void:
	var water_coords: Array[Vector2i] = []
	var ground_coords: Array[Vector2i] = []
	for y in range(start_y + 3, start_y - chunk_size, -1):
		_check_segment_ended()
		# Calculating left and right borders of river.
		var left: int = floori(_river_center - _river_width * 0.5)
		var right: int = ceili(_river_center + _river_width * 0.5)
		for x in range(-1, _tile_map_width + 1):
			var tile_coords: Vector2i = Vector2i(x, y)
			if x <= left or x >= right:
				ground_coords.append(tile_coords)
			else:
				water_coords.append(tile_coords)
		_maybe_spawn_content(y, left, right)
				
	tile_map.set_cells_terrain_connect(water_coords, TERRAIN_SET, WATER_TERRAIN)
	tile_map.set_cells_terrain_connect(ground_coords, TERRAIN_SET, GROUND_TERRAIN)
	

func _check_segment_ended() -> void:
	if _segment_rows_left > 0:
		_segment_rows_left -= 1
		return

	_segment_rows_left = randi_range(min_segment_length, max_segment_length)
	var river_center_offset: int = [-1, 1].pick_random()
	var river_width_offset: int = [-1, 1].pick_random()
	_river_center = clampi(
		_river_center + river_center_offset,
		16,
		24
	)
	_river_width = clampi(
		_river_width + river_width_offset,
		min_river_width,
		max_river_width,
	)


func _maybe_spawn_content(y: int, left: int, right: int) -> void:
	# Not spawning enemies close to each other.
	if _enemy_spawned_last_row > 0:
		_enemy_spawned_last_row -= 1
		return

	# Not spawning enemies at the start of the level.
	if y > _tile_map_height - do_not_spawn_until_row:
		return

	var maybe_spawn: float = randf()
	# Maybe spawn boat.
	if maybe_spawn < boat_possibility:
		var boat_position: Vector2 = tile_map.map_to_local(Vector2(randi_range(left + 3, right - 3), y)).round()
		var boat_rotation: float = 0.0
		# Rotate boat if it closer to right shore.
		if boat_position.x > tile_map.map_to_local(Vector2(_river_center, y)).x:
			boat_rotation = 180.0
			
		enemy_spawner.spawn_boat(boat_position, boat_rotation)
		_enemy_spawned_last_row = spawn_threshold_rows
	elif maybe_spawn >= boat_possibility and maybe_spawn < boat_possibility + helicopter_possibility:
		var helicopter_position: Vector2 = tile_map.map_to_local(Vector2(randi_range(3, _tile_map_width - 3), y)).round()
		var helicopter_rotation: float = 0.0
		# Rotate boat if it closer to right shore.
		if helicopter_position.x > tile_map.map_to_local(Vector2(_river_center, y)).x:
			helicopter_rotation = 180.0
		enemy_spawner.spawn_helicopter(helicopter_position, helicopter_rotation)
		_enemy_spawned_last_row = spawn_threshold_rows
