class_name StormWeatherEffects
extends Node2D

## Prototype Phase 3 — rain, wind, and lightning driven by player storm stats.

@onready var _rain: CPUParticles2D = $RainParticles
@onready var _flash: ColorRect = $LightningLayer/Flash
@onready var _bolt: Line2D = $LightningLayer/Bolt

var _player: Node2D = null
var _stats: Node = null
var _wind_vector: Vector2 = Vector2.ZERO
var _wind_angle: float = 0.0
var _lightning_cooldown: float = 0.0
var _flash_timer: float = 0.0


func _ready() -> void:
	add_to_group("storm_weather")
	_flash.visible = false
	_flash.modulate.a = 0.0
	_bolt.visible = false
	_rain.emitting = false
	GameManager.player_registered.connect(_on_player_registered)
	if GameManager.player != null:
		_on_player_registered(GameManager.player)


func _physics_process(delta: float) -> void:
	if _stats == null or _player == null:
		_wind_vector = Vector2.ZERO
		return

	global_position = _player.global_position
	_update_wind(delta)
	_update_rain()
	_update_lightning(delta)
	_update_flash(delta)


func get_wind_vector() -> Vector2:
	return _wind_vector


func _on_player_registered(player: Node2D) -> void:
	_player = player
	_stats = player.get_node_or_null("Stats")
	if _stats != null:
		_stats.stats_changed.connect(_on_stats_changed)


func _on_stats_changed(
	_humidity: float,
	_heat: float,
	_energy: float,
	_instability: float
) -> void:
	_update_rain()


func _update_wind(delta: float) -> void:
	var energy_ratio: float = _stats.get_energy_ratio()
	var instability_ratio: float = _stats.get_instability_ratio()
	var intensity: float = clampf(energy_ratio * 0.55 + instability_ratio * 0.45, 0.0, 1.0)

	_wind_angle += delta * (PrototypeBalance.WIND_DIRECTION_SPEED + intensity * 1.2)
	var strength: float = lerpf(
		PrototypeBalance.WIND_STRENGTH_MIN,
		PrototypeBalance.WIND_STRENGTH_MAX,
		intensity
	)
	_wind_vector = Vector2(cos(_wind_angle), sin(_wind_angle)) * strength

	# Rain falls slightly with the wind for a cohesive look.
	_rain.direction = (_wind_vector.normalized() * 0.35 + Vector2(0.1, 1.0)).normalized()


func _update_rain() -> void:
	var humidity: float = _stats.humidity
	var energy: float = _stats.storm_energy
	var humidity_ready: float = clampf(
		(humidity - PrototypeBalance.RAIN_MIN_HUMIDITY)
		/ (PrototypeBalance.MAX_HUMIDITY - PrototypeBalance.RAIN_MIN_HUMIDITY),
		0.0,
		1.0
	)
	var energy_ready: float = clampf(
		(energy - PrototypeBalance.RAIN_MIN_ENERGY)
		/ (PrototypeBalance.MAX_STORM_ENERGY - PrototypeBalance.RAIN_MIN_ENERGY),
		0.0,
		1.0
	)
	var rain_intensity: float = minf(humidity_ready, energy_ready)

	if rain_intensity <= 0.02:
		_rain.emitting = false
		return

	_rain.emitting = true
	_rain.amount = maxi(
		1,
		int(
			lerpf(
				float(PrototypeBalance.RAIN_PARTICLES_MIN),
				float(PrototypeBalance.RAIN_PARTICLES_MAX),
				rain_intensity
			)
		)
	)


func _update_lightning(delta: float) -> void:
	_lightning_cooldown = maxf(_lightning_cooldown - delta, 0.0)
	if _flash_timer > 0.0:
		return
	if _lightning_cooldown > 0.0:
		return

	var instability: float = _stats.instability
	var energy: float = _stats.storm_energy
	if instability < PrototypeBalance.LIGHTNING_MIN_INSTABILITY:
		return
	if energy < PrototypeBalance.LIGHTNING_MIN_ENERGY:
		return

	var charge: float = clampf(
		_stats.get_instability_ratio() * 0.6 + _stats.get_energy_ratio() * 0.4,
		0.0,
		1.0
	)
	var strike_chance: float = charge * 0.04
	if randf() > strike_chance:
		return

	_trigger_lightning(charge)


func _trigger_lightning(charge: float) -> void:
	_flash_timer = PrototypeBalance.LIGHTNING_FLASH_DURATION
	_flash.visible = true
	_flash.modulate = Color(1.0, 1.0, 1.0, PrototypeBalance.LIGHTNING_FLASH_ALPHA * charge)

	var canvas_xform: Transform2D = get_viewport().get_canvas_transform()
	var bolt_end: Vector2 = canvas_xform * _player.global_position
	var bolt_start: Vector2 = bolt_end + Vector2(
		randf_range(-100.0, 100.0),
		randf_range(-220.0, -90.0)
	)
	_bolt.points = PackedVector2Array([bolt_start, bolt_end])
	_bolt.default_color = Color(0.85, 0.92, 1.0, 0.9)
	_bolt.width = lerpf(2.0, 4.5, charge)
	_bolt.visible = true

	_lightning_cooldown = lerpf(
		PrototypeBalance.LIGHTNING_COOLDOWN_MAX,
		PrototypeBalance.LIGHTNING_COOLDOWN_MIN,
		charge
	)


func _update_flash(delta: float) -> void:
	if _flash_timer <= 0.0:
		_flash.visible = false
		_bolt.visible = false
		return

	_flash_timer = maxf(_flash_timer - delta, 0.0)
	var fade: float = _flash_timer / PrototypeBalance.LIGHTNING_FLASH_DURATION
	_flash.modulate.a = PrototypeBalance.LIGHTNING_FLASH_ALPHA * fade
	if _flash_timer <= 0.0:
		_bolt.visible = false
