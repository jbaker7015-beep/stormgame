extends Node2D

## Drawn rain streaks and wind lines — high contrast, always visible (Phase 3).

const MAX_DROPS: int = 90
const DEFAULT_DROP_ZONE_RADIUS: float = 160.0

var _drop_zone_radius: float = DEFAULT_DROP_ZONE_RADIUS
var rain_intensity: float = 0.0
var wind_direction: Vector2 = Vector2(1.0, 0.0)
var wind_intensity: float = 0.0

var _drops: Array[Dictionary] = []
var _time: float = 0.0


func _ready() -> void:
	z_index = 10
	_init_drops()


func _init_drops() -> void:
	_drops.clear()
	for i in MAX_DROPS:
		_drops.append(_make_drop())


func set_drop_zone_radius(radius: float) -> void:
	_drop_zone_radius = maxf(radius, 40.0)


func _make_drop() -> Dictionary:
	var angle: float = randf() * TAU
	var dist: float = randf() * _drop_zone_radius
	return {
		"offset": Vector2(cos(angle), sin(angle)) * dist,
		"speed": randf_range(140.0, 260.0),
		"length": randf_range(10.0, 22.0),
	}


func set_weather(rain: float, wind_dir: Vector2, wind_power: float) -> void:
	rain_intensity = rain
	wind_intensity = wind_power
	if wind_dir.length_squared() > 0.01:
		wind_direction = wind_dir.normalized()
	visible = rain > 0.02 or wind_power > 0.08


func _process(delta: float) -> void:
	if not visible:
		return
	_time += delta
	if rain_intensity > 0.02:
		_animate_rain(delta)
	if wind_intensity > 0.08:
		queue_redraw()
	elif rain_intensity > 0.02:
		queue_redraw()


func _animate_rain(delta: float) -> void:
	var fall_dir: Vector2 = (wind_direction * 0.45 + Vector2(0.0, 1.0)).normalized()
	var active_count: int = int(lerpf(25.0, float(MAX_DROPS), rain_intensity))

	for i in active_count:
		var drop: Dictionary = _drops[i]
		drop["offset"] += fall_dir * drop["speed"] * delta
		if drop["offset"].length() > _drop_zone_radius:
			_drops[i] = _make_drop()

	queue_redraw()


func _draw() -> void:
	if wind_intensity > 0.08:
		_draw_wind_lines()

	if rain_intensity > 0.02:
		_draw_rain_streaks()


func _draw_rain_streaks() -> void:
	var fall_dir: Vector2 = (wind_direction * 0.45 + Vector2(0.0, 1.0)).normalized()
	var active_count: int = int(lerpf(25.0, float(MAX_DROPS), rain_intensity))
	var drop_color := Color(0.92, 0.96, 1.0, lerpf(0.55, 0.95, rain_intensity))
	var line_width: float = lerpf(1.5, 3.0, rain_intensity)

	for i in active_count:
		var drop: Dictionary = _drops[i]
		var start: Vector2 = drop["offset"]
		var end: Vector2 = start + fall_dir * drop["length"]
		draw_line(start, end, drop_color, line_width)


func _draw_wind_lines() -> void:
	var line_color := Color(1.0, 1.0, 1.0, lerpf(0.25, 0.65, wind_intensity))
	var count: int = int(lerpf(4.0, 12.0, wind_intensity))
	var perp := Vector2(-wind_direction.y, wind_direction.x)

	for i in count:
		var angle_step: float = TAU * float(i) / float(count)
		var offset: Vector2 = Vector2(cos(angle_step), sin(angle_step)) * 70.0
		var start: Vector2 = offset - wind_direction * 28.0
		var end: Vector2 = offset + wind_direction * lerpf(35.0, 75.0, wind_intensity)
		draw_line(start, end, line_color, lerpf(1.5, 3.0, wind_intensity))
		# Small arrow head
		var tip: Vector2 = end
		var back: Vector2 = tip - wind_direction * 10.0
		draw_line(tip, back + perp * 5.0, line_color, 1.5)
		draw_line(tip, back - perp * 5.0, line_color, 1.5)
