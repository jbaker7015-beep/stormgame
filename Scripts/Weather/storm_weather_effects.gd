class_name StormWeatherEffects
extends Node2D

## Per-storm rain, wind, and lightning driven by the parent pocket's stats (Phase 3/5).

@onready var _visuals: Node2D = $WeatherVisuals
@onready var _rain_tint: ColorRect = $RainOverlayLayer/RainTint
@onready var _flash: ColorRect = $LightningLayer/Flash
@onready var _bolt: Line2D = $LightningLayer/Bolt
@onready var _local_flash: ColorRect = $LocalLightning/LocalFlash
@onready var _local_bolt: Line2D = $LocalLightning/LocalBolt

var _storm_body: CharacterBody2D = null
var _stats: MoisturePocketStats = null
var _wind_vector: Vector2 = Vector2.ZERO
var _wind_angle: float = 0.0
var _rain_intensity: float = 0.0
var _lightning_cooldown: float = 0.0
var _flash_timer: float = 0.0
var _wind_phase_offset: float = 0.0
var _flash_peak_alpha: float = 0.0


func _ready() -> void:
	_storm_body = get_parent() as CharacterBody2D
	if _storm_body == null:
		push_warning("StormWeatherEffects must be a child of a CharacterBody2D storm pocket.")
		return

	_stats = _storm_body.get_node_or_null("Stats") as MoisturePocketStats
	_wind_phase_offset = randf() * TAU

	call_deferred("_finalize_storm_binding")


func _finalize_storm_binding() -> void:
	_configure_layers_for_storm_type()
	_reset_lightning_visuals()

	if not is_player_storm():
		_visuals.set_drop_zone_radius(PrototypeBalance.AI_WEATHER_DROP_RADIUS)


func is_player_storm() -> bool:
	return _storm_body != null and _storm_body == GameManager.player


func _configure_layers_for_storm_type() -> void:
	_rain_tint.visible = false
	_rain_tint.modulate.a = 0.0
	$RainOverlayLayer.visible = is_player_storm()
	$LightningLayer.visible = is_player_storm()
	$LocalLightning.visible = not is_player_storm()


func _reset_lightning_visuals() -> void:
	_flash.visible = false
	_flash.modulate.a = 0.0
	_bolt.visible = false
	_local_flash.visible = false
	_local_flash.modulate.a = 0.0
	_local_bolt.visible = false


func _physics_process(delta: float) -> void:
	if _stats == null or _storm_body == null:
		_wind_vector = Vector2.ZERO
		_rain_intensity = 0.0
		_apply_visuals(0.0, 0.0)
		return

	var storm_intensity: float = compute_storm_intensity(_stats)
	_update_wind(delta, storm_intensity)
	_rain_intensity = compute_rain_intensity(_stats, not is_player_storm())
	_apply_visuals(_rain_intensity, storm_intensity)

	_update_lightning(delta)
	_update_flash(delta)


func get_wind_vector() -> Vector2:
	return _wind_vector


func get_bound_storm() -> CharacterBody2D:
	return _storm_body


static func compute_storm_intensity(stats: MoisturePocketStats) -> float:
	return clampf(
		stats.get_energy_ratio() * 0.5 + stats.get_instability_ratio() * 0.5,
		0.0,
		1.0
	)


func _update_wind(delta: float, intensity: float) -> void:
	_wind_angle += delta * (PrototypeBalance.WIND_DIRECTION_SPEED + intensity * 1.2)
	_wind_angle += _wind_phase_offset * 0.02
	var strength: float = lerpf(
		PrototypeBalance.WIND_STRENGTH_MIN,
		PrototypeBalance.WIND_STRENGTH_MAX,
		intensity
	)
	if not is_player_storm():
		strength *= PrototypeBalance.AI_WEATHER_WIND_MULT
	_wind_vector = Vector2(cos(_wind_angle), sin(_wind_angle)) * strength


static func compute_rain_intensity(stats: MoisturePocketStats, apply_ai_scale: bool) -> float:
	var humidity: float = stats.humidity
	var energy: float = stats.storm_energy
	var instability: float = stats.instability

	if energy < PrototypeBalance.RAIN_MIN_ENERGY:
		return 0.0

	var energy_ready: float = clampf(
		(energy - PrototypeBalance.RAIN_MIN_ENERGY)
		/ (PrototypeBalance.MAX_STORM_ENERGY - PrototypeBalance.RAIN_MIN_ENERGY),
		0.0,
		1.0
	)
	var humidity_ready: float = clampf(
		(humidity - PrototypeBalance.RAIN_MIN_HUMIDITY)
		/ (PrototypeBalance.MAX_HUMIDITY - PrototypeBalance.RAIN_MIN_HUMIDITY),
		0.0,
		1.0
	)
	var instability_ready: float = clampf(
		(instability - PrototypeBalance.RAIN_MIN_INSTABILITY)
		/ (PrototypeBalance.MAX_INSTABILITY - PrototypeBalance.RAIN_MIN_INSTABILITY),
		0.0,
		1.0
	)

	var moisture_factor: float = maxf(humidity_ready, instability_ready * 0.85)
	var rain: float = minf(energy_ready, moisture_factor)
	if apply_ai_scale:
		rain *= PrototypeBalance.AI_WEATHER_RAIN_MULT
	return rain


func _apply_visuals(rain: float, storm_intensity: float) -> void:
	_visuals.set_weather(rain, _wind_vector, storm_intensity)

	if not is_player_storm():
		return

	var show_tint: bool = rain > 0.08
	_rain_tint.visible = show_tint
	_rain_tint.modulate = Color(0.72, 0.82, 0.98, lerpf(0.0, 0.22, rain))


func _update_lightning(delta: float) -> void:
	_lightning_cooldown = maxf(_lightning_cooldown - delta, 0.0)
	if _flash_timer > 0.0:
		return
	if _lightning_cooldown > 0.0:
		return

	if _stats.instability < PrototypeBalance.LIGHTNING_MIN_INSTABILITY:
		return
	if _stats.storm_energy < PrototypeBalance.LIGHTNING_MIN_ENERGY:
		return

	var charge: float = clampf(
		_stats.get_instability_ratio() * 0.6 + _stats.get_energy_ratio() * 0.4,
		0.0,
		1.0
	)
	var strike_chance: float = charge * (0.04 if is_player_storm() else 0.028)
	if randf() > strike_chance:
		return

	_trigger_lightning(charge)


func _trigger_lightning(charge: float) -> void:
	_flash_timer = PrototypeBalance.LIGHTNING_FLASH_DURATION
	_flash_peak_alpha = PrototypeBalance.LIGHTNING_FLASH_ALPHA * charge

	if is_player_storm():
		_trigger_screen_lightning(charge)
		StormAudioManager.play_thunder(charge)
	else:
		_trigger_local_lightning(charge)
		StormAudioManager.play_ai_thunder(charge, _storm_body.global_position)

	_lightning_cooldown = lerpf(
		PrototypeBalance.LIGHTNING_COOLDOWN_MAX,
		PrototypeBalance.LIGHTNING_COOLDOWN_MIN,
		charge
	)


func _trigger_screen_lightning(charge: float) -> void:
	_flash.visible = true
	_flash.modulate = Color(1.0, 1.0, 1.0, PrototypeBalance.LIGHTNING_FLASH_ALPHA * charge)

	var canvas_xform: Transform2D = get_viewport().get_canvas_transform()
	var bolt_end: Vector2 = canvas_xform * _storm_body.global_position
	var bolt_start: Vector2 = bolt_end + Vector2(
		randf_range(-100.0, 100.0),
		randf_range(-220.0, -90.0)
	)
	_bolt.points = PackedVector2Array([bolt_start, bolt_end])
	_bolt.visible = true
	_bolt.width = lerpf(2.0, 4.5, charge)


func _trigger_local_lightning(charge: float) -> void:
	var flash_alpha: float = _flash_peak_alpha * 0.85
	_local_flash.visible = true
	_local_flash.modulate = Color(0.92, 0.95, 1.0, flash_alpha)
	_local_flash.scale = Vector2.ONE * lerpf(0.7, 1.15, charge)

	var bolt_start: Vector2 = Vector2(
		randf_range(-55.0, 55.0),
		randf_range(-150.0, -70.0)
	)
	_local_bolt.points = PackedVector2Array([bolt_start, Vector2.ZERO])
	_local_bolt.visible = true
	_local_bolt.width = lerpf(1.5, 3.5, charge)
	_local_bolt.default_color = Color(0.9, 0.82, 0.72, 0.95)


func _update_flash(delta: float) -> void:
	if _flash_timer <= 0.0:
		_reset_lightning_visuals()
		return

	_flash_timer = maxf(_flash_timer - delta, 0.0)
	var alpha_scale: float = _flash_timer / PrototypeBalance.LIGHTNING_FLASH_DURATION
	var faded_alpha: float = _flash_peak_alpha * alpha_scale

	if is_player_storm() and _flash.visible:
		_flash.modulate.a = faded_alpha
	elif _local_flash.visible:
		_local_flash.modulate.a = faded_alpha * 0.85

	if _flash_timer <= 0.0:
		_bolt.visible = false
		_local_bolt.visible = false
