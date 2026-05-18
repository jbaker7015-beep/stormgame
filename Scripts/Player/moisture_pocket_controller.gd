class_name MoisturePocketController
extends CharacterBody2D

## S2: straight-line heading drag from storm center + coast on last heading when route ends.

const StormTrajectoryClass = preload("res://Scripts/Storm/storm_trajectory.gd")

@onready var _stats: Node = $Stats
@onready var _weather: StormWeatherEffects = $StormWeather

var _trajectory: StormTrajectory = StormTrajectoryClass.new()
var _is_drawing: bool = false
var _drag_end_world: Vector2 = Vector2.ZERO
var _replan_cooldown: float = 0.0
var _last_heading: Vector2 = Vector2.RIGHT
var _steering_indicator: Vector2 = Vector2.ZERO


func _ready() -> void:
	add_to_group("player_storm")
	GameManager.register_player(self)
	_last_heading = Vector2.RIGHT
	_commit_heading(global_position + _last_heading * 160.0)


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
		if mb.button_index == MOUSE_BUTTON_RIGHT and mb.pressed:
			_cancel_pathing()
			get_viewport().set_input_as_handled()
			return
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				if _replan_cooldown <= 0.0:
					_begin_draw()
			elif _is_drawing:
				_end_draw()
	elif event is InputEventMouseMotion and _is_drawing:
		_update_drag_end(event.position)


func _cancel_pathing() -> void:
	_is_drawing = false
	_trajectory.clear()
	# Keep _last_heading — storm continues drifting that way.


func get_path_draw_state() -> Dictionary:
	var draft: PackedVector2Array = PackedVector2Array()
	if _is_drawing:
		draft = PackedVector2Array([global_position, _drag_end_world])
	return {
		"draft": draft,
		"active": _trajectory.waypoints,
		"target": _trajectory.get_target() if _trajectory.has_active_target() else global_position,
		"has_target": _trajectory.has_active_target(),
	}


func _begin_draw() -> void:
	_is_drawing = true
	_drag_end_world = global_position


func _update_drag_end(screen_pos: Vector2) -> void:
	if not _is_drawing:
		return
	var world: Vector2 = _clamp_point_to_play_rect(_screen_to_world(screen_pos))
	var offset: Vector2 = world - global_position
	var dist: float = offset.length()
	if dist < 0.001:
		_drag_end_world = global_position
		return
	dist = clampf(dist, 0.0, PrototypeBalance.TRAJECTORY_MAX_DRAG_PX)
	_drag_end_world = global_position + offset.normalized() * dist


func _end_draw() -> void:
	if not _is_drawing:
		return
	_is_drawing = false
	var offset: Vector2 = _drag_end_world - global_position
	if offset.length() >= PrototypeBalance.TRAJECTORY_MIN_DRAG_PX:
		_commit_heading(_drag_end_world)
	_replan_cooldown = PrototypeBalance.TRAJECTORY_REPLAN_COOLDOWN


func _commit_heading(world_target: Vector2) -> void:
	world_target = _clamp_point_to_play_rect(world_target)
	var offset: Vector2 = world_target - global_position
	if offset.length_squared() < 0.001:
		return
	_last_heading = offset.normalized()
	_trajectory.set_path(PackedVector2Array([global_position, world_target]))


func _apply_trajectory_movement(delta: float) -> void:
	var desired: Vector2

	if _trajectory.has_active_target():
		_trajectory.advance_through(global_position, PrototypeBalance.TRAJECTORY_ARRIVAL_RADIUS)
		if _trajectory.has_active_target():
			var target: Vector2 = _trajectory.get_target()
			var to_target: Vector2 = target - global_position
			if to_target.length_squared() > 1.0:
				_last_heading = to_target.normalized()
				desired = _blend_with_environment(_last_heading * PrototypeBalance.TRAJECTORY_CRUISE_SPEED)
			else:
				desired = _blend_with_environment(_last_heading * PrototypeBalance.TRAJECTORY_CRUISE_SPEED)
		else:
			# Reached waypoint — keep going in last heading (no full stop).
			desired = _blend_with_environment(_last_heading * PrototypeBalance.TRAJECTORY_CRUISE_SPEED)
	else:
		# No active route — coast on last heading.
		desired = _blend_with_environment(_last_heading * PrototypeBalance.TRAJECTORY_CRUISE_SPEED)

	if desired.length_squared() > 0.001 and desired.length() > PrototypeBalance.TRAJECTORY_MAX_SPEED:
		desired = desired.normalized() * PrototypeBalance.TRAJECTORY_MAX_SPEED

	velocity = velocity.move_toward(desired, PrototypeBalance.TRAJECTORY_ACCELERATION * delta)


func _blend_with_environment(planned_vel: Vector2) -> Vector2:
	if planned_vel.length_squared() > 0.01:
		_last_heading = planned_vel.normalized()
	var env_vel: Vector2 = _get_environmental_velocity()
	_steering_indicator = env_vel
	return planned_vel.lerp(env_vel, PrototypeBalance.TRAJECTORY_ENV_BLEND)


func _get_environmental_velocity() -> Vector2:
	var env := Vector2.ZERO
	if has_node("/root/AtmosphereGrid"):
		var sample: Dictionary = AtmosphereGrid.sample_at_world(global_position)
		env = sample.get("steering_wind", Vector2.ZERO)
	if _weather != null:
		env += _weather.get_wind_vector() * 0.35
	return env


func _apply_legacy_movement(delta: float) -> void:
	var input_vector: Vector2 = _read_legacy_input()
	if input_vector.length_squared() > 0.0:
		velocity = velocity.move_toward(
			input_vector.normalized() * PrototypeBalance.MOVE_SPEED,
			PrototypeBalance.MOVE_ACCELERATION * delta
		)
		_last_heading = input_vector.normalized()
	else:
		velocity = velocity.move_toward(
			_last_heading * PrototypeBalance.TRAJECTORY_CRUISE_SPEED,
			PrototypeBalance.TRAJECTORY_ACCELERATION * delta
		)
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
	return get_canvas_transform().affine_inverse() * screen_pos


func _clamp_to_play_bounds() -> void:
	global_position = _clamp_point_to_play_rect(global_position)


func _clamp_point_to_play_rect(point: Vector2) -> Vector2:
	var rect: Rect2 = WorldMapConfig.PLAY_RECT
	return Vector2(
		clampf(point.x, rect.position.x, rect.end.x),
		clampf(point.y, rect.position.y, rect.end.y)
	)
