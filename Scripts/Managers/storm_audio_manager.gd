extends Node

## Storm atmosphere — procedural wind/rain loops + rolling thunder (reliable, no shared WAV streams).

const WeatherFx = preload("res://Scripts/Weather/storm_weather_effects.gd")
const Synth = preload("res://Scripts/Managers/storm_audio_synth.gd")

@onready var _wind_player: AudioStreamPlayer = $WindPlayer
@onready var _rain_player: AudioStreamPlayer = $RainPlayer
@onready var _hum_player: AudioStreamPlayer = $HumPlayer
@onready var _thunder_player: AudioStreamPlayer = $ThunderPlayer
@onready var _ai_wind_player: AudioStreamPlayer = $AIWindPlayer
@onready var _ai_rain_player: AudioStreamPlayer = $AIRainPlayer
@onready var _ai_hum_player: AudioStreamPlayer = $AIHumPlayer
@onready var _ai_thunder_player: AudioStreamPlayer = $AIThunderPlayer

var _wind_playback: AudioStreamGeneratorPlayback
var _rain_playback: AudioStreamGeneratorPlayback
var _hum_playback: AudioStreamGeneratorPlayback
var _ai_wind_playback: AudioStreamGeneratorPlayback
var _ai_rain_playback: AudioStreamGeneratorPlayback
var _ai_hum_playback: AudioStreamGeneratorPlayback

var _wind_volume: float = 0.0
var _rain_volume: float = 0.0
var _hum_volume: float = 0.0
var _player_rain_level: float = 0.0
var _ai_wind_volume: float = 0.0
var _ai_rain_volume: float = 0.0
var _ai_hum_volume: float = 0.0

var _wind_noise: float = 0.1
var _rain_noise: float = 0.2
var _hum_noise: float = 0.05
var _ai_wind_noise: float = 0.35
var _ai_rain_noise_state: float = 0.5
var _ai_hum_noise: float = 0.15
var _synth_time: float = 0.0

var _generators_ready: bool = false


func _ready() -> void:
	_wind_volume = PrototypeBalance.AUDIO_WIND_IDLE
	GameManager.player_registered.connect(_on_player_registered)
	call_deferred("_init_generators")


func _init_generators() -> void:
	await get_tree().process_frame
	await get_tree().process_frame

	_wind_playback = _start_generator(_wind_player)
	_rain_playback = _start_generator(_rain_player)
	_hum_playback = _start_generator(_hum_player)
	_ai_wind_playback = _start_generator(_ai_wind_player)
	_ai_rain_playback = _start_generator(_ai_rain_player)
	_ai_hum_playback = _start_generator(_ai_hum_player)
	_generators_ready = true


func _start_generator(player: AudioStreamPlayer) -> AudioStreamGeneratorPlayback:
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = Synth.SAMPLE_RATE
	stream.buffer_length = 0.12
	player.stream = stream
	player.bus = &"Master"
	player.play()
	var playback: AudioStreamGeneratorPlayback = player.get_stream_playback() as AudioStreamGeneratorPlayback
	return playback


func _physics_process(delta: float) -> void:
	_synth_time += delta
	_sync_player_atmosphere()
	_sync_ai_storm_audio()
	_apply_output_levels()


func _process(_delta: float) -> void:
	if not _generators_ready:
		return

	_push_wind(_wind_playback, _wind_volume, false)
	_push_rain(_rain_playback, _player_rain_level, false)
	_push_hum(_hum_playback, _hum_volume)
	_push_wind(_ai_wind_playback, _ai_wind_volume, true)
	_push_rain(_ai_rain_playback, _normalize(_ai_rain_volume, PrototypeBalance.AUDIO_AI_RAIN_MAX), true)
	_push_hum(
		_ai_hum_playback,
		_normalize(_ai_hum_volume, PrototypeBalance.AUDIO_AI_HUM_MAX),
		true
	)


func _push_wind(playback: AudioStreamGeneratorPlayback, amp: float, is_ai: bool) -> void:
	if playback == null or amp <= 0.0005:
		return
	var to_fill: int = playback.get_frames_available()
	for _i in to_fill:
		var result: Dictionary = Synth.fill_wind_frame(amp, _ai_wind_noise if is_ai else _wind_noise, _synth_time)
		if is_ai:
			_ai_wind_noise = result["noise_state"]
		else:
			_wind_noise = result["noise_state"]
		var s: float = result["sample"]
		playback.push_frame(Vector2(s, s))


func _push_rain(
	playback: AudioStreamGeneratorPlayback,
	rain_level: float,
	is_ai: bool = false
) -> void:
	if playback == null or rain_level <= 0.0005:
		return
	var amp: float = rain_level * (PrototypeBalance.AUDIO_AI_RAIN_MAX if is_ai else PrototypeBalance.AUDIO_RAIN_MAX)
	var noise_state: float = _ai_rain_noise_state if is_ai else _rain_noise
	var to_fill: int = playback.get_frames_available()
	for _i in to_fill:
		var result: Dictionary = Synth.fill_rain_frame(amp, noise_state, _synth_time)
		if is_ai:
			_ai_rain_noise_state = result["noise_state"]
		else:
			_rain_noise = result["noise_state"]
		var s: float = result["sample"]
		playback.push_frame(Vector2(s, s))


func _push_hum(playback: AudioStreamGeneratorPlayback, amp: float, is_ai: bool = false) -> void:
	if playback == null or amp <= 0.0005:
		return
	var noise_state: float = _ai_hum_noise if is_ai else _hum_noise
	var to_fill: int = playback.get_frames_available()
	for _i in to_fill:
		var result: Dictionary = Synth.fill_hum_frame(amp, noise_state, _synth_time)
		if is_ai:
			_ai_hum_noise = result["noise_state"]
		else:
			_hum_noise = result["noise_state"]
		var s: float = result["sample"]
		playback.push_frame(Vector2(s, s))


func _apply_output_levels() -> void:
	var wind_norm: float = _normalize(_wind_volume, PrototypeBalance.AUDIO_WIND_MAX)
	var rain_norm: float = clampf(_player_rain_level, 0.0, 1.0)
	var hum_norm: float = _normalize(_hum_volume, PrototypeBalance.AUDIO_HUM_MAX)

	_wind_player.volume_db = maxf(lerpf(-14.0, 2.0, wind_norm), -10.0)

	if rain_norm > 0.01:
		_rain_player.volume_db = lerpf(-8.0, 6.0, rain_norm)
	else:
		_rain_player.volume_db = -55.0

	if hum_norm > 0.015:
		_hum_player.volume_db = lerpf(-22.0, -6.0, hum_norm)
	else:
		_hum_player.volume_db = -50.0

	var ai_wind_norm: float = _normalize(_ai_wind_volume, PrototypeBalance.AUDIO_AI_WIND_MAX)
	var ai_rain_norm: float = _normalize(_ai_rain_volume, PrototypeBalance.AUDIO_AI_RAIN_MAX)
	var ai_hum_norm: float = _normalize(_ai_hum_volume, PrototypeBalance.AUDIO_AI_HUM_MAX)

	_ai_wind_player.volume_db = _loop_db(ai_wind_norm, -28.0, -4.0)
	_ai_rain_player.volume_db = _loop_db(ai_rain_norm, -30.0, -2.0)
	_ai_hum_player.volume_db = _loop_db(ai_hum_norm, -34.0, -8.0)


func _loop_db(normalized: float, silent_db: float, loud_db: float) -> float:
	if normalized <= 0.01:
		return silent_db
	return lerpf(silent_db, loud_db, normalized)


func _normalize(amount: float, max_amount: float) -> float:
	if max_amount <= 0.0001:
		return 0.0
	return clampf(amount / max_amount, 0.0, 1.0)


func _on_player_registered(_player: Node2D) -> void:
	_sync_player_atmosphere()


func _sync_player_atmosphere() -> void:
	var stats: MoisturePocketStats = GameManager.get_player_stats() as MoisturePocketStats
	if stats == null:
		_wind_volume = PrototypeBalance.AUDIO_WIND_IDLE
		_rain_volume = 0.0
		_player_rain_level = 0.0
		_hum_volume = PrototypeBalance.AUDIO_HUM_IDLE
		return

	var rain: float = WeatherFx.compute_rain_intensity(stats, false)
	var storm: float = WeatherFx.compute_storm_intensity(stats)
	var stage: int = int(stats.get_growth_stage())
	_apply_player_volumes(rain, storm, stage)
	_player_rain_level = rain


func _sync_ai_storm_audio() -> void:
	var player: Node2D = GameManager.player
	if player == null:
		_ai_wind_volume = 0.0
		_ai_rain_volume = 0.0
		_ai_hum_volume = 0.0
		return

	var rain_mix: float = 0.0
	var wind_mix: float = 0.0
	var hum_mix: float = 0.0
	var max_stage: int = MoisturePocketStats.GrowthStage.MATURE_THUNDERSTORM

	for storm in AIManager.ai_storms:
		if not is_instance_valid(storm):
			continue

		var stats: MoisturePocketStats = storm.get_node_or_null("Stats") as MoisturePocketStats
		if stats == null:
			continue

		var distance: float = player.global_position.distance_to(storm.global_position)
		var proximity: float = _proximity_falloff(distance)
		if proximity <= 0.001:
			continue

		var rain: float = WeatherFx.compute_rain_intensity(stats, true)
		var storm_intensity: float = WeatherFx.compute_storm_intensity(stats)
		var stage_norm: float = clampf(
			float(stats.get_growth_stage()) / float(max_stage),
			0.0,
			1.0
		)
		var strength: float = clampf(
			storm_intensity * 0.58 + rain * 0.42,
			0.0,
			1.0
		) * lerpf(0.6, 1.18, stage_norm)
		var weight: float = proximity * strength

		rain_mix += rain * weight
		wind_mix += storm_intensity * weight
		hum_mix += (stage_norm * 0.5 + strength * 0.5) * weight

	rain_mix = _soft_cap_mix(rain_mix)
	wind_mix = _soft_cap_mix(wind_mix)
	hum_mix = _soft_cap_mix(hum_mix)

	_ai_rain_volume = rain_mix * PrototypeBalance.AUDIO_AI_RAIN_MAX * 1.4
	_ai_wind_volume = wind_mix * PrototypeBalance.AUDIO_AI_WIND_MAX * 1.4
	_ai_hum_volume = hum_mix * PrototypeBalance.AUDIO_AI_HUM_MAX


func _apply_player_volumes(
	rain_intensity: float,
	storm_intensity: float,
	growth_stage: int
) -> void:
	var max_stage: int = MoisturePocketStats.GrowthStage.MATURE_THUNDERSTORM
	var stage_norm: float = clampf(float(growth_stage) / float(max_stage), 0.0, 1.0)
	var combined: float = clampf(
		storm_intensity * 0.55 + rain_intensity * 0.45,
		0.0,
		1.0
	)
	var stage_lift: float = lerpf(0.82, 1.42, stage_norm)

	_rain_volume = lerpf(0.0, PrototypeBalance.AUDIO_RAIN_MAX, rain_intensity) * stage_lift
	_wind_volume = lerpf(
		PrototypeBalance.AUDIO_WIND_IDLE,
		PrototypeBalance.AUDIO_WIND_MAX,
		storm_intensity
	) * lerpf(0.88, 1.32, stage_norm)
	_hum_volume = lerpf(
		PrototypeBalance.AUDIO_HUM_IDLE,
		PrototypeBalance.AUDIO_HUM_MAX,
		stage_norm
	) + combined * PrototypeBalance.AUDIO_HUM_COMBINED_BOOST


func play_thunder(intensity: float = 1.0) -> void:
	_play_rolling_thunder(_thunder_player, intensity, 0.0, -6.0, 6.0)


func play_ai_thunder(intensity: float, world_position: Vector2) -> void:
	var player: Node2D = GameManager.player
	if player == null:
		return

	var distance: float = player.global_position.distance_to(world_position)
	var proximity: float = _proximity_falloff(distance)
	if proximity <= 0.02:
		return

	var audible_charge: float = clampf(intensity * proximity, 0.0, 1.0)
	var pan: float = clampf(
		(world_position.x - player.global_position.x) / PrototypeBalance.AUDIO_AI_PAN_RANGE,
		-1.0,
		1.0
	)
	_play_rolling_thunder(_ai_thunder_player, audible_charge, pan, -20.0, -2.0)


func _play_rolling_thunder(
	player: AudioStreamPlayer,
	intensity: float,
	stereo_pan: float,
	min_db: float,
	max_db: float
) -> void:
	var charge: float = clampf(intensity, 0.0, 1.0)
	player.stream = Synth.build_rolling_thunder(charge, stereo_pan)
	player.volume_db = lerpf(min_db, max_db, charge)
	player.pitch_scale = randf_range(0.92, 1.05)
	player.play()


func _proximity_falloff(distance: float) -> float:
	if distance >= PrototypeBalance.AUDIO_AI_MAX_HEAR_DISTANCE:
		return 0.0
	var linear: float = inverse_lerp(
		PrototypeBalance.AUDIO_AI_MAX_HEAR_DISTANCE,
		PrototypeBalance.AUDIO_AI_FULL_HEAR_DISTANCE,
		distance
	)
	return linear * linear


func _soft_cap_mix(value: float) -> float:
	var cap: float = PrototypeBalance.AUDIO_AI_MIX_CAP
	if value <= cap:
		return value
	return cap + (value - cap) * 0.25
