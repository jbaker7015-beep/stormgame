class_name MoisturePocketController
extends CharacterBody2D

## S2: click-drag path planning + slow motion blended with atmospheric steering.

const StormTrajectoryClass = preload("res://Scripts/Storm/storm_trajectory.gd")

@onready var _stats: Node = $Stats
@onready var _weather: StormWeatherEffects = $StormWeather

var _trajectory: StormTrajectory = StormTrajectoryClass.new()
var _draft_points: PackedVector2Array = PackedVector2Array()
var _is_drawing: bool = false
var _replan_cooldown: float = 0.0
var _steering_indicator: Vector2 = Vector2.ZERO


func _ready() -> void:
	add_to_group("player_storm")
	GameManager.register_player(self)
	# Start with a short path hint ahead so the storm drifts immediately.
	_commit_path_from_points(PackedVector2Array([global_position, global_position + Vector2(120, 0)]))


func _physics_process(delta: float) -> void:
	if GameManager.is_paused:
		return

	_replan_cooldown = maxf(0.0, _replan_cooldown - delta)

	if PrototypeBalance.LEGACY_WASD_MOVEMENT and _read_legacy_input().length_squared() > 0.001:
		_apply_legacy_movement(delta)
	else:
		_apply_trajectory_movement(delta)

	_clamp_to_play_bounds()
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if PrototypeBalance.LEGACY_WASD_MOVEMENT:
		return

	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.button_index != MOUSE_BUTTON_LEFT:
			return
		if mb.pressed:
			if _replan_cooldown <= 0.0:
				_begin_draw(mb.position)
		elif _is_drawing:
			_end_draw(mb.position)
	elif event is InputEventMouseMotion and _is_drawing:
		_extend_draw(event.position)


func get_path_draw_state() -> Dictionary:
	return {
		"draft": _draft_points,
		"active": _trajectory.waypoints,
		"target": _trajectory.get_target() if _trajectory.has_active_target() else global_position,
		"has_target": _trajectory.has_active_target(),
	}


func _begin_draw(screen_pos: Vector2) -> void:
	_is_drawing = true
	_draft_points = PackedVector2Array()
	_draft_points.append(global_position)
	_append_draft_point(_screen_to_world(screen_pos))


func _extend_draw(screen_pos: Vector2) -> void:
	if not _is_drawing:
		return
	_append_draft_point(_screen_to_world(screen_pos))


func _end_draw(screen_pos: Vector2) -> void:
	if not _is_drawing:
		return
	_is_drawing = false
	_append_draft_point(_screen_to_world(screen_pos))
	_commit_path_from_points(_draft_points)
	_draft_points = PackedVector2Array()


func _append_draft_point(world_pos: Vector2) -> void:
	world_pos = _clamp_point_to_play_rect(world_pos)
	if _draft_points.is_empty():
		_draft_points.append(world_pos)
		return
	var last: Vector2 = _draft_points[_draft_points.size() - 1]
	if last.distance_to(world_pos) >= PrototypeBalance.TRAJECTORY_MIN_SEGMENT_PX:
		_draft_points.append(world_pos)


func _commit_path_from_points(points: PackedVector2Array) -> void:
	if points.size() < 2:
		return
	var cleaned := _simplify_path(points)
	if cleaned.size() < 2:
		return
	_trajectory.set_path(cleaned)
	_replan_cooldown = PrototypeBalance.TRAJECTORY_REPLAN_COOLDOWN


func _simplify_path(points: PackedVector2Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	var max_pts: int = PrototypeBalance.TRAJECTORY_MAX_WAYPOINTS
	var step: int = maxi(1, int(ceil(float(points.size() - 1) / float(max_pts - 1))))
	for i in range(points.size()):
		if i == 0 or i == points.size() - 1 or i % step == 0:
			if out.is_empty() or out[out.size() - 1].distance_to(points[i]) > 8.0:
				out.append(points[i])
	if out.size() < 2:
		out = points
	return out


func _apply_trajectory_movement(delta: float) -> void:
	if not _trajectory.has_active_target():
		velocity = velocity.move_toward(Vector2.ZERO, PrototypeBalance.TRAJECTORY_FRICTION * delta)
		return

	_trajectory.advance_through(global_position, PrototypeBalance.TRAJECTORY_ARRIVAL_RADIUS)
	if not _trajectory.has_active_target():
		velocity = velocity.move_toward(Vector2.ZERO, PrototypeBalance.TRAJECTORY_FRICTION * delta)
		return

	var target: Vector2 = _trajectory.get_target()
	var to_target: Vector2 = target - global_position
	if to_target.length_squared() < 1.0:
		return

	var planned_dir: Vector2 = to_target.normalized()
	var planned_speed: float = PrototypeBalance.TRAJECTORY_CRUISE_SPEED
	var planned_vel: Vector2 = planned_dir * planned_speed

	var env_vel: Vector2 = _get_environmental_velocity()
	_steering_indicator = env_vel
	var blend: float = PrototypeBalance.TRAJECTORY_ENV_BLEND
	var desired: Vector2 = planned_vel.lerp(env_vel, blend)

	if desired.length() > PrototypeBalance.TRAJECTORY_MAX_SPEED:
		desired = desired.normalized() * PrototypeBalance.TRAJECTORY_MAX_SPEED

	velocity = velocity.move_toward(desired, PrototypeBalance.TRAJECTORY_ACCELERATION * delta)


func _get_environmental_velocity() -> Vector2:
	var env := Vector2.ZERO
	if has_node("/root/AtmosphereGrid"):
		var sample: Dictionary = AtmosphereGrid.sample_at_world(global_position)
		env = sample.get("steering_wind", Vector2.ZERO)
	if _weather != null:
		var wx: Vector2 = _weather.get_wind_vector()
		env += wx * 0.35
	return env


func _apply_legacy_movement(delta: float) -> void:
	var input_vector: Vector2 = _read_legacy_input()
	if input_vector.length_squared() > 0.0:
		velocity = velocity.move_toward(
			input_vector.normalized() * PrototypeBalance.MOVE_SPEED,
			PrototypeBalance.MOVE_ACCELERATION * delta
		)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, PrototypeBalance.MOVE_FRICTION * delta)
	var wind: Vector2 = _get_wind_vector()
	if wind.length_squared() > 0.01:
		velocity = velocity.move_toward(wind, PrototypeBalance.WIND_PUSH_ACCEL * delta)


func _get_wind_vector() -> Vector2:
	if _weather != null:
		return _weather.get_wind_vector()
	return Vector2.ZERO


func _read_legacy_input() -> Vector2:
	if not Input.is_key_pressed(KEY_SHIFT):
		return Vector2.ZERO
	var input_vector: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	if input_vector.length_squared() > 0.001:
		return input_vector
	var fallback := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP):
		fallback.y -= 1.0
	if Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN):
		fallback.y += 1.0
	if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT):
		fallback.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT):
		fallback.x += 1.0
	return fallback


func _screen_to_world(screen_pos: Vector2) -> Vector2:
	var canvas_xform: Transform2D = get_canvas_transform()
	return canvas_xform.affine_inverse() * screen_pos


func _clamp_to_play_bounds() -> void:
	global_position = _clamp_point_to_play_rect(global_position)


func _clamp_point_to_play_rect(point: Vector2) -> Vector2:
	var rect: Rect2 = WorldMapConfig.PLAY_RECT
	return Vector2(
		clampf(point.x, rect.position.x, rect.end.x),
		clampf(point.y, rect.position.y, rect.end.y)
	)
