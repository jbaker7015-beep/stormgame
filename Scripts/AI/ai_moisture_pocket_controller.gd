class_name AIMoisturePocketController
extends CharacterBody2D

## AI storm pocket — seeks biomes and competes for resources (Prototype Phase 5).

@export var ai_display_name: String = "AI Storm"

@onready var _stats: MoisturePocketStats = $Stats
@onready var _weather: StormWeatherEffects = $StormWeather

var _target_position: Vector2 = Vector2.ZERO
var _think_timer: float = 0.0


func _ready() -> void:
	add_to_group("ai_storm")
	_target_position = global_position
	_think_timer = randf_range(0.0, PrototypeBalance.AI_THINK_INTERVAL)
	AIManager.register_ai_storm(self)


func _exit_tree() -> void:
	AIManager.unregister_ai_storm(self)


func _physics_process(delta: float) -> void:
	if GameManager.is_paused:
		return

	_think_timer -= delta
	if _think_timer <= 0.0:
		_think_timer = PrototypeBalance.AI_THINK_INTERVAL
		_target_position = _choose_target_position()

	_move_toward_target(delta)
	_apply_wind_drift(delta)
	move_and_slide()


func _choose_target_position() -> Vector2:
	var best_score: float = -INF
	var best_position: Vector2 = global_position

	for zone in WeatherManager.active_zones:
		if not zone is AtmosphericZone:
			continue

		var atmospheric_zone: AtmosphericZone = zone as AtmosphericZone
		var rates: Vector3 = atmospheric_zone.get_contribution_rates()
		var zone_pos: Vector2 = atmospheric_zone.global_position
		var score: float = _score_zone(atmospheric_zone, rates, zone_pos)

		if score > best_score:
			best_score = score
			best_position = zone_pos

	if best_score <= -INF:
		return global_position

	return best_position


func _score_zone(zone: AtmosphericZone, rates: Vector3, zone_pos: Vector2) -> float:
	var humid_rate: float = rates.x
	var heat_rate: float = rates.y
	var score: float = 0.0

	var humid_need: float = 1.0 - clampf(
		_stats.humidity / PrototypeBalance.MAX_HUMIDITY, 0.0, 1.0
	)
	var heat_need: float = 1.0 - clampf(
		_stats.heat_energy / PrototypeBalance.MAX_HEAT, 0.0, 1.0
	)
	var energy_need: float = 1.0 - clampf(
		_stats.storm_energy / PrototypeBalance.MAX_STORM_ENERGY, 0.0, 1.0
	)

	score += humid_rate * humid_need * 2.2
	score += heat_rate * heat_need * 2.2

	# Favor overlapping humid + heat when trying to synthesize energy.
	if _stats.humidity > 8.0 and _stats.heat_energy > 8.0 and energy_need > 0.2:
		if humid_rate > 0.0 and heat_rate > 0.0:
			score += 35.0

	# Prefer zones that help the next evolution step.
	score += _stats.get_evolution_progress() * 8.0

	var distance: float = global_position.distance_to(zone_pos)
	score -= distance * 0.08

	# Light competition — avoid crowding the player.
	var player: Node2D = GameManager.player
	if player != null:
		var player_distance: float = player.global_position.distance_to(zone_pos)
		if player_distance < zone.zone_radius + PrototypeBalance.AI_PLAYER_COMPETE_RADIUS:
			score -= PrototypeBalance.AI_PLAYER_COMPETE_PENALTY

	# Mild competition between AI storms.
	for other in AIManager.ai_storms:
		if other == self:
			continue
		var other_distance: float = other.global_position.distance_to(zone_pos)
		if other_distance < zone.zone_radius * 0.85:
			score -= PrototypeBalance.AI_STORM_COMPETE_PENALTY

	return score


func _move_toward_target(delta: float) -> void:
	var to_target: Vector2 = _target_position - global_position
	if to_target.length_squared() < 64.0:
		velocity = velocity.move_toward(
			Vector2.ZERO,
			PrototypeBalance.MOVE_FRICTION * delta
		)
		return

	var desired: Vector2 = to_target.normalized() * PrototypeBalance.AI_MOVE_SPEED
	velocity = velocity.move_toward(
		desired,
		PrototypeBalance.MOVE_ACCELERATION * delta
	)


func _apply_wind_drift(delta: float) -> void:
	var wind: Vector2 = _weather.get_wind_vector() if _weather != null else Vector2.ZERO
	if wind.length_squared() > 0.01:
		velocity = velocity.move_toward(wind, PrototypeBalance.WIND_PUSH_ACCEL * delta * 0.85)
