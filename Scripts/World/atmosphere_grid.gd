extends Node

## S1: Chunked atmosphere fields (CAPE, CIN, Td, shear, …) per climate zone + daily seed.

const ClimateConfig = preload("res://Systems/Config/climate_zone_config.gd")

const CELL_SIZE: int = 80

var day_seed: int = 1
var season: ClimateConfig.Season = ClimateConfig.Season.SUMMER
var _cols: int = 0
var _rows: int = 0
var _fields: PackedFloat32Array = PackedFloat32Array()
# 9 floats per cell: cape, cin, dewpoint_f, temp_f, pw_mm, shear_ms, srh, steer_x, steer_y
const _FLOATS_PER_CELL: int = 9


func _ready() -> void:
	day_seed = GameManager.day_seed
	season = GameManager.season
	regenerate()
	GameManager.day_seed_changed.connect(_on_day_seed_changed)


func _on_day_seed_changed(seed_value: int) -> void:
	day_seed = seed_value
	season = GameManager.season
	regenerate()


func regenerate() -> void:
	var rect: Rect2 = WorldMapConfig.PLAY_RECT
	_cols = maxi(1, int(ceil(rect.size.x / float(CELL_SIZE))))
	_rows = maxi(1, int(ceil(rect.size.y / float(CELL_SIZE))))
	_fields = PackedFloat32Array()
	_fields.resize(_cols * _rows * _FLOATS_PER_CELL)
	var rng := RandomNumberGenerator.new()
	rng.seed = day_seed
	var rect_pos: Vector2 = rect.position
	for row in _rows:
		for col in _cols:
			var center := rect_pos + Vector2(
				(float(col) + 0.5) * float(CELL_SIZE),
				(float(row) + 0.5) * float(CELL_SIZE)
			)
			_write_cell(col, row, _sample_at(center, rng))


func set_day(seed_value: int, new_season: ClimateConfig.Season) -> void:
	day_seed = seed_value
	season = new_season
	regenerate()


func sample_at_world(world_pos: Vector2) -> Dictionary:
	var col_row := _world_to_cell(world_pos)
	return _read_cell(col_row.x, col_row.y)


func get_zone_id_at(world_pos: Vector2) -> int:
	return ClimateConfig.get_zone_id_at(world_pos)


func get_zone_name_at(world_pos: Vector2) -> String:
	var zid: int = get_zone_id_at(world_pos)
	if zid < 0:
		return "Open"
	return ClimateConfig.get_zone_metadata(zid).get("name", "?")


func _sample_at(world_pos: Vector2, rng: RandomNumberGenerator) -> PackedFloat32Array:
	var zid: int = ClimateConfig.get_zone_id_at(world_pos)
	if zid < 0:
		zid = 4
	var b: Dictionary = ClimateConfig.get_baselines(zid, season)
	var n: float = rng.randf_range(-1.0, 1.0)
	var patch: float = rng.randf_range(-0.5, 0.5)
	var out := PackedFloat32Array()
	out.resize(_FLOATS_PER_CELL)
	out[0] = maxf(0.0, b["cape"] + n * 450.0 + patch * 200.0)
	out[1] = b["cin"] + n * 25.0
	out[2] = b["dewpoint_f"] + n * 4.0
	out[3] = b["temp_f"] + n * 5.0
	out[4] = maxf(5.0, b["pw_mm"] + n * 8.0)
	out[5] = maxf(0.0, b["shear_ms"] + n * 4.0)
	out[6] = maxf(0.0, b["srh"] + n * 40.0)
	var steer: Vector2 = b["steering"] + Vector2(n * 3.0, patch * 2.0)
	out[7] = steer.x
	out[8] = steer.y
	return out


func _world_to_cell(world_pos: Vector2) -> Vector2i:
	var rect: Rect2 = WorldMapConfig.PLAY_RECT
	var local: Vector2 = world_pos - rect.position
	var col: int = clampi(int(local.x / float(CELL_SIZE)), 0, _cols - 1)
	var row: int = clampi(int(local.y / float(CELL_SIZE)), 0, _rows - 1)
	return Vector2i(col, row)


func _cell_index(col: int, row: int) -> int:
	return (row * _cols + col) * _FLOATS_PER_CELL


func _write_cell(col: int, row: int, values: PackedFloat32Array) -> void:
	var idx: int = _cell_index(col, row)
	for i in _FLOATS_PER_CELL:
		_fields[idx + i] = values[i]


func _read_cell(col: int, row: int) -> Dictionary:
	var idx: int = _cell_index(col, row)
	return {
		"cape": _fields[idx + 0],
		"cin": _fields[idx + 1],
		"dewpoint_f": _fields[idx + 2],
		"surface_temperature_f": _fields[idx + 3],
		"precipitable_water_mm": _fields[idx + 4],
		"bulk_shear_0_6km_ms": _fields[idx + 5],
		"srh_0_1km": _fields[idx + 6],
		"steering_wind": Vector2(_fields[idx + 7], _fields[idx + 8]),
	}


func get_grid_size() -> Vector2i:
	return Vector2i(_cols, _rows)


func get_cell_size() -> int:
	return CELL_SIZE


func get_play_rect() -> Rect2:
	return WorldMapConfig.PLAY_RECT
