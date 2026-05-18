class_name MoisturePocketController
extends CharacterBody2D

## Smooth top-down movement for the moisture pocket (WASD / arrow keys).

@onready var _stats: Node = $Stats
@onready var _weather: StormWeatherEffects = $StormWeather


func _ready() -> void:
	add_to_group("player_storm")
	GameManager.register_player(self)


func _physics_process(delta: float) -> void:
	if GameManager.is_paused:
		return

	var input_vector: Vector2 = _read_movement_input()

	if input_vector.length_squared() > 0.0:
		velocity = velocity.move_toward(
			input_vector.normalized() * PrototypeBalance.MOVE_SPEED,
			PrototypeBalance.MOVE_ACCELERATION * delta
		)
	else:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			PrototypeBalance.MOVE_FRICTION * delta
		)

	# Phase 3: wind drift — blend toward wind velocity so it is easy to feel.
	var wind: Vector2 = _get_wind_vector()
	if wind.length_squared() > 0.01:
		velocity = velocity.move_toward(wind, PrototypeBalance.WIND_PUSH_ACCEL * delta)

	move_and_slide()


func _get_wind_vector() -> Vector2:
	if _weather != null:
		return _weather.get_wind_vector()
	return Vector2.ZERO


func _read_movement_input() -> Vector2:
	var input_vector: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	if input_vector.length_squared() > 0.001:
		return input_vector

	# Fallback when Input Map actions are missing (e.g. wrong project.godot opened).
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
