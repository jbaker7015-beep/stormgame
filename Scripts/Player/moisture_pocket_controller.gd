class_name MoisturePocketController
extends CharacterBody2D

## Smooth top-down movement for the moisture pocket (WASD / arrow keys).

@onready var _stats: Node = $Stats


func _ready() -> void:
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

	# Phase 3: wind drift pushes the pocket even without player input.
	var wind: Vector2 = _get_wind_vector()
	if wind.length_squared() > 0.01:
		velocity += wind * delta

	move_and_slide()


func _get_wind_vector() -> Vector2:
	var weather_nodes := get_tree().get_nodes_in_group("storm_weather")
	for node in weather_nodes:
		if node.has_method("get_wind_vector"):
			return node.get_wind_vector()
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
